//
//  RenderEngine.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import UIKit
import AVFoundation

protocol RenderEngine {
    func makePreviewFrame(_ project: Project, completion: @escaping (UIImage?) -> Void)
    func makePreviewAsset(_ project: Project, completion: @escaping (AVAsset?) -> Void)
}

final class RenderEngineImpl {
    
    // MARK: - Private methods
    
    private func makeVideoComposition(for videoTrack: AVMutableCompositionTrack) -> AVVideoComposition {
        let videoLayer = makeVideLayer(for: videoTrack)
        let animationLayer = makeAnimationLayer(for: videoTrack, sublayers: [
            videoLayer,
            makeImageLayer(.add)
        ])
        
        // TODO: - Remove !
        let videoComposition = AVMutableVideoComposition(propertiesOf: videoTrack.asset!)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: animationLayer)
        
        return videoComposition
    }
    
    private func makeVideLayer(for videoTrack: AVMutableCompositionTrack) -> CALayer {
        let frame = CGRect(origin: .zero, size: videoTrack.naturalSize)
        
        let videoLayer = CALayer()
        videoLayer.frame = frame
        
        return videoLayer
    }
    
    private func makeAnimationLayer(for videoTrack: AVMutableCompositionTrack, sublayers: [CALayer]) -> CALayer {
        let frame = CGRect(origin: .zero, size: videoTrack.naturalSize)
        
        let animationLayer = CALayer()
        animationLayer.frame = frame
        
        sublayers.forEach({
            animationLayer.addSublayer($0)
        })
        
        return animationLayer
    }
    
    // TODO: - Add multiple images
    private func makeImageLayer(_ asset: UIImage) -> CALayer {
        let imageLayer = CALayer()
        imageLayer.contents = asset.cgImage
        imageLayer.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0)
        return imageLayer
    }
    
    private func addVideoAssets(_ assets: [AVAsset], for videoTrack: AVMutableCompositionTrack) {
        assets.forEach({
            guard let assetVideoTrack = $0.tracks(withMediaType: .video).first else { return }
            
            let assetTimeRange = CMTimeRange(start: .zero, duration: $0.duration)
            
            try? videoTrack.insertTimeRange(assetTimeRange, of: assetVideoTrack, at: videoTrack.timeRange.duration)
        })
    }
    
}

// MARK: - RenderEngine

extension RenderEngineImpl: RenderEngine {
    
    func makePreviewFrame(_ project: Project, completion: @escaping (UIImage?) -> Void) {
        makePreviewAsset(project) {
            guard let asset = $0 else {
                completion(nil)
                return
            }
            
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            if let image = try? imageGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil) {
                completion(UIImage(cgImage: image))
            } else {
                completion(nil)
            }
        }
    }
    
    func makePreviewAsset(_ project: Project, completion: @escaping (AVAsset?) -> Void) {
//        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output-\(Int(Date().timeIntervalSince1970)).mp4")
//
//        let processor = VideoOverlayProcessor(inputURL: project.template.backgroundURL!, outputURL: outputURL)
//
//        let videoSize = processor.videoSize
//        let videoDuration = processor.videoDuration
//
//        let textOverlay = ImageOverlay(image: .add, frame: CGRect(x: .zero, y: .zero, width: 200.0, height: 200.0), delay: .zero, duration: videoDuration)
//        processor.addOverlay(textOverlay)
//
//        processor.process { [weak self] (exportSession) in
//            guard let exportSession = exportSession else { return }
//
//            if (exportSession.status == .completed) {
//                DispatchQueue.main.async {
//                    completion(AVAsset(url: exportSession.outputURL!))
//                }
//            }
//        }
        
        let composition = AVMutableComposition()

        guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(nil)
            return
        }

        // TODO: - Remove !
        addVideoAssets([project.template.asset!], for: videoTrack)

        let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let documentDirectoryURL = URL(fileURLWithPath: documentDirectory).appendingPathComponent("result.mp4")

        removeFileIfExists(documentDirectoryURL)

        let videoComposition = makeVideoComposition(for: videoTrack)

//        let instruction = AVMutableVideoCompositionInstruction()
//        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
//        _ = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
//
//        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
//        instruction.layerInstructions = [layerInstruction]
//        videoComposition.instructions = [instruction]

        export(composition: composition, videoComposition: videoComposition, outputURL: documentDirectoryURL) {
            let asset = AVAsset(url: $0)

            completion(asset)
        }
    }
    
    // TODO: - Add error handling
    private func removeFileIfExists(_ documentDirectoryURL: URL) {
        do {
            if FileManager.default.fileExists(atPath: documentDirectoryURL.path) {
                try FileManager.default.removeItem(at: documentDirectoryURL)
            }
        } catch {
            print(error)
        }
    }
    
    private func export(composition: AVComposition, videoComposition: AVVideoComposition, outputURL: URL, completion: @escaping (URL) -> Void) {
        let presetName = Environment.isSimulator ? AVAssetExportPresetPassthrough : AVAssetExportPresetHighestQuality
        
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: presetName) else { return }
        
        exportSession.videoComposition = videoComposition
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.exportAsynchronously { [weak exportSession] in
            guard let url = exportSession?.outputURL else { return }
            
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }
    
}
