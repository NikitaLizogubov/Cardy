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
    
    private func makeVideoComposition(_ project: Project, for videoTrack: AVMutableCompositionTrack) -> AVVideoComposition {
        let videoLayer = makeVideLayer(for: videoTrack)
        let animationLayer = makeAnimationLayer(for: videoTrack)
        
        animationLayer.addSublayer(videoLayer)
        
        project.images.compactMap({ $0 }).forEach({
            let imageLayer = makeImageLayer($0)
            
            animationLayer.addSublayer(imageLayer)
        })
        
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
    
    private func makeAnimationLayer(for videoTrack: AVMutableCompositionTrack) -> CALayer {
        let frame = CGRect(origin: .zero, size: videoTrack.naturalSize)
        
        let animationLayer = CALayer()
        animationLayer.frame = frame
        
        return animationLayer
    }
    
    // TODO: - Add multiple images
    private func makeImageLayer(_ asset: UIImage) -> CALayer {
        let imageLayer = CALayer()
        imageLayer.contents = asset.cgImage
        imageLayer.frame = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0)
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

        let videoComposition = makeVideoComposition(project, for: videoTrack)

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
