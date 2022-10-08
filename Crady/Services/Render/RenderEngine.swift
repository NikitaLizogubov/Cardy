//
//  RenderEngine.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import UIKit
import AVFoundation
import VideoToolbox

protocol RenderEngine {
    func makePreviewAsset(_ project: Project, completion: @escaping (AVAsset?) -> Void)
}

final class RenderEngineImpl {
    
    // MARK: - Private properties
    
    private let fileManager: FileManager
    private let renderLayerFactory: RenderLayeFactory
    
    // Constants
    
    private let TRANSITION_DURATION = CMTime(seconds: 3, preferredTimescale: 1)
    
    // MARK: - Init
    
    init(fileManager: FileManager, renderLayerFactory: RenderLayeFactory) {
        self.fileManager = fileManager
        self.renderLayerFactory = renderLayerFactory
    }
    
    // MARK: - Private methods
    
    private func makeAssets(_ project: Project, completion: @escaping ([AVAsset]) -> Void){
        var assets: [AVAsset] = []
        
        let images: [UIImage] = project.content.compactMap({
            guard let url = $0.backgroundURL, let data = try? Data(contentsOf: url) else { return nil }
            
            return UIImage(data: data)
        })
        
        let group = DispatchGroup()
        
        images.enumerated().forEach({ (index, image) in
            group.enter()
            
            let settings = RenderSettings(filename: "background\(index)")
            let imageAnimator = ImageAnimator(renderSettings: settings)
            
            imageAnimator.images = [image, image]
            imageAnimator.render {
                let asset = AVAsset(url: $0)
                
                assets.append(asset)
                
                group.leave()
            }
        })
        
        group.notify(queue: .main) {
            completion(assets)
        }
    }
    
    private func makeOverlayAssets(_ project: Project, _ assets: [AVAsset], completion: @escaping ([AVAsset]) -> Void) {
        var overlaidAssets: [AVAsset] = []
        
        let group = DispatchGroup()
        
        assets.enumerated().forEach({ (index, asset) in
            group.enter()
            
            let composition = AVMutableComposition()
            
            guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                return
            }
            
            addVideoAssets(asset, for: videoTrack)
            
            let documentDirectoryURL = fileManager.makeTampDirectory("videTrack\(index).mov")

            fileManager.removeFileIfExists(documentDirectoryURL)
            
            let videoComposition = makeVideoComposition(project.content[index].fragments, for: videoTrack)
            
            export(composition: composition, videoComposition: videoComposition, outputURL: documentDirectoryURL) {
                let asset = AVAsset(url: $0)
                
                overlaidAssets.append(asset)

                group.leave()
            }
        })
        
        group.notify(queue: .main) {
            completion(overlaidAssets)
        }
    }
    
    private func makeVideoComposition(_ fragments: [Fragment], for videoTrack: AVMutableCompositionTrack) -> AVVideoComposition {
        let videoLayer = renderLayerFactory.makeVideLayer(size: Project.size)
        let animationLayer = renderLayerFactory.makeAnimationLayer(size: Project.size)
        
        if !Environment.isSimulator {
            animationLayer.addSublayer(videoLayer)
        }
        
        fragments.forEach({
            let imageLayer = renderLayerFactory.makeFragmentLayer(fragment: $0, size: Project.size)
            
            animationLayer.addSublayer(imageLayer)
        })
        
        // TODO: - Remove !
        let videoComposition = AVMutableVideoComposition(propertiesOf: videoTrack.asset!)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: animationLayer)
        
        return videoComposition
    }
    
    private func addVideoAssets(_ asset: AVAsset, for videoTrack: AVMutableCompositionTrack) {
        guard let assetVideoTrack = asset.tracks(withMediaType: .video).first else { return }
        
        let assetTimeRange = CMTimeRange(start: .zero, duration: asset.duration)
        
        try? videoTrack.insertTimeRange(assetTimeRange, of: assetVideoTrack, at: videoTrack.timeRange.duration)
    }
    
}

// MARK: - RenderEngine

extension RenderEngineImpl: RenderEngine {
    
    func makePreviewAsset(_ project: Project, completion: @escaping (AVAsset?) -> Void) {
        makeAssets(project) { [self] in
            makeOverlayAssets(project, $0) { [self] in
                let composition = AVMutableComposition()
                
                guard let videoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                    return
                }
                
                $0.forEach({
                    addVideoAssets($0, for: videoTrack)
                })
                
                let documentDirectoryURL = fileManager.makeTampDirectory("result.mov")

                fileManager.removeFileIfExists(documentDirectoryURL)
                
                export(composition: composition, videoComposition: nil, outputURL: documentDirectoryURL) {
                    let asset = AVAsset(url: $0)

                    completion(asset)
                }
            }
        }
    }
    
    private func export(composition: AVComposition, videoComposition: AVVideoComposition?, outputURL: URL, completion: @escaping (URL) -> Void) {
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
        
        exportSession.videoComposition = videoComposition
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = false
        exportSession.exportAsynchronously { [weak exportSession] in
            guard let url = exportSession?.outputURL else { return }
            
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }
    
    private func buildCompositionTracks(composition: AVMutableComposition, videos: [AVAsset]) -> Void {
        let videoTracks = videos.map({ _ in
            composition.addMutableTrack(
                withMediaType: AVMediaType.video,
                preferredTrackID: kCMPersistentTrackID_Invalid
            )
        })
    
//        var audioTrackA: AVMutableCompositionTrack?
//        var audioTrackB: AVMutableCompositionTrack?
    
        var cursorTime = CMTime.zero
    
        var index = 0
        videos.forEach { (asset) in
            do {
                let trackIndex = index % 2
                let currentVideoTrack = videoTracks[index]
    
                if TRANSITION_DURATION <= asset.duration {
                    let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
                    try currentVideoTrack?.insertTimeRange(
                        timeRange,
                        of: asset.tracks(withMediaType: AVMediaType.video)[0],
                        at: cursorTime
                    )
//                    if let audioAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first {
//                        var currentAudioTrack: AVMutableCompositionTrack?
//                        switch trackIndex {
//                        case 0:
//                            if audioTrackA == nil {
//                                audioTrackA = composition.addMutableTrack(
//                                    withMediaType: AVMediaType.audio,
//                                    preferredTrackID: kCMPersistentTrackID_Invalid
//                                )
//                            }
//                            currentAudioTrack = audioTrackA
//                        case 1:
//                            if audioTrackB == nil {
//                                audioTrackB = composition.addMutableTrack(
//                                    withMediaType: AVMediaType.audio,
//                                    preferredTrackID: kCMPersistentTrackID_Invalid
//                                )
//                            }
//                            currentAudioTrack = audioTrackB
//                        default:
//                            print("MovieTransitionsVC " + #function + ": Only two audio tracks were expected")
//                        }
//                        try currentAudioTrack?.insertTimeRange(
//                            CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
//                            of: audioAssetTrack,
//                            at: cursorTime
//                        )
//                    }
                }
    
                // Overlap clips by tranition duration
                cursorTime = CMTimeAdd(cursorTime, asset.duration)
                cursorTime = CMTimeSubtract(cursorTime, TRANSITION_DURATION)
            } catch {
                // Could not add track
                print("MovieTransitionsVC " + #function + ": " + error.localizedDescription)
            }
            index += 1
        }
    }
    
    // Function to calculate both the pass through time and the transition time ranges
    private func calculateTimeRanges(assets: [AVAsset]) -> (passThroughTimeRanges: [NSValue], transitionTimeRanges: [NSValue]) {
        var passThroughTimeRanges:[NSValue] = [NSValue]()
        var transitionTimeRanges:[NSValue] = [NSValue]()
        var cursorTime = CMTime.zero
    
        for i in 0...(assets.count - 1) {
            let asset = assets[i]
            if TRANSITION_DURATION <= asset.duration {
                var timeRange = CMTimeRangeMake(start: cursorTime, duration: asset.duration)
    
                if i > 0 {
                    timeRange.start = CMTimeAdd(timeRange.start, TRANSITION_DURATION)
                    timeRange.duration = CMTimeSubtract(timeRange.duration, TRANSITION_DURATION)
                }
    
                if i + 1 < assets.count {
                    timeRange.duration = CMTimeSubtract(timeRange.duration, TRANSITION_DURATION)
                }
    
                passThroughTimeRanges.append(NSValue.init(timeRange: timeRange))
    
                cursorTime = CMTimeAdd(cursorTime, asset.duration)
                cursorTime = CMTimeSubtract(cursorTime, TRANSITION_DURATION)
    
                if i + 1 < assets.count {
                    timeRange = CMTimeRangeMake(start: cursorTime, duration: TRANSITION_DURATION)
                    transitionTimeRanges.append(NSValue.init(timeRange: timeRange))
                }
            }
        }
        return (passThroughTimeRanges, transitionTimeRanges)
    }
    
    // Build the video composition and instructions.
    private func buildVideoCompositionAndInstructions(composition: AVMutableComposition, assets: [AVAsset]) -> AVMutableVideoComposition {
    
        // Create the passthrough and transition time ranges.
        let timeRanges = calculateTimeRanges(assets: assets)
    
        // Create a mutable composition instructions object
        var compositionInstructions = [AVMutableVideoCompositionInstruction]()
    
        //Get the list of asset tracks and tell compiler they are a list of asset tracks.
        let tracks = composition.tracks(withMediaType: AVMediaType.video) as [AVAssetTrack]
    
        // Create a video composition object
        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
    
        for i in 0...(timeRanges.passThroughTimeRanges.count - 1) {
            let trackIndex = i % 2
            let currentTrack = tracks[trackIndex]
    
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = timeRanges.passThroughTimeRanges[i].timeRangeValue
    
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(
                assetTrack: currentTrack)
            instruction.layerInstructions = [layerInstruction]
    
            compositionInstructions.append(instruction)
    
            if i < timeRanges.transitionTimeRanges.count {
    
                let instruction = AVMutableVideoCompositionInstruction()
                instruction.timeRange = timeRanges.transitionTimeRanges[i].timeRangeValue
    
                // Determine the foreground and background tracks.
                let fgTrack = tracks[trackIndex]
                let bgTrack = tracks[1 - trackIndex]
    
                // Create the "from layer" instruction.
                let fLInstruction = AVMutableVideoCompositionLayerInstruction(
                    assetTrack: fgTrack)
    
                // Make the opacity ramp and apply it to the from layer instruction.
                fLInstruction.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity:0.0,
                                             timeRange: instruction.timeRange)
    
                let tLInstruction = AVMutableVideoCompositionLayerInstruction(
                    assetTrack: bgTrack)
    
                instruction.layerInstructions = [fLInstruction, tLInstruction]
                compositionInstructions.append(instruction)
            }
        }
    
        videoComposition.instructions = compositionInstructions
        videoComposition.renderSize = composition.naturalSize
    
        return videoComposition
    }
    
}
