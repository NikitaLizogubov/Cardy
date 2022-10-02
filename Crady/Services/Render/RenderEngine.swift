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
    
    // MARK: - Private properties
    
    private let renderLayerFactory: RenderLayeFactory
    
    // MARK: - Init
    
    init(renderLayerFactory: RenderLayeFactory = RenderLayeFactoryImpl()) {
        self.renderLayerFactory = renderLayerFactory
    }
    
    // MARK: - Private methods
    
    private func makeVideoComposition(_ project: Project, for videoTrack: AVMutableCompositionTrack) -> AVVideoComposition {
        let images = project.images.compactMap({ $0 })
        let positions = project.template.imageFragments.map({ $0.position })
        
        let videoLayer = renderLayerFactory.makeVideLayer(for: videoTrack)
        let animationLayer = renderLayerFactory.makeAnimationLayer(for: videoTrack)
        let imageLayers = renderLayerFactory.makeImageLayers(images, positions: positions, for: videoTrack)
        
        animationLayer.addSublayer(videoLayer)
        animationLayer.addSublayers(imageLayers)
        
        // TODO: - Remove !
        let videoComposition = AVMutableVideoComposition(propertiesOf: videoTrack.asset!)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: animationLayer)
        
        return videoComposition
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
