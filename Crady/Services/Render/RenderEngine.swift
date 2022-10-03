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
    
    private let fileManager: FileManager
    private let renderLayerFactory: RenderLayeFactory
    
    // MARK: - Init
    
    init(fileManager: FileManager = .default, renderLayerFactory: RenderLayeFactory = RenderLayeFactoryImpl()) {
        self.fileManager = fileManager
        self.renderLayerFactory = renderLayerFactory
    }
    
    // MARK: - Private methods
    
    private func makeVideoComposition(_ project: Project, for videoTrack: AVMutableCompositionTrack) -> AVVideoComposition {
        //let images = project.images.compactMap({ $0 })
        //let positions = project.template.imageFragments.map({ $0.position })
        
        let videoLayer = renderLayerFactory.makeVideLayer(for: videoTrack)
        let animationLayer = renderLayerFactory.makeAnimationLayer(for: videoTrack)
        //let imageLayers = renderLayerFactory.makeImageLayers(images, positions: positions, for: videoTrack)
        
        if !Environment.isSimulator {
            animationLayer.addSublayer(videoLayer)
        }
        
        //animationLayer.addSublayers(imageLayers)
        
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

        addVideoAssets([], for: videoTrack)
        
        let documentDirectoryURL = fileManager.makeTampDirectory("result.mov")

        fileManager.removeFileIfExists(documentDirectoryURL)

        let videoComposition = makeVideoComposition(project, for: videoTrack)

        export(composition: composition, videoComposition: videoComposition, outputURL: documentDirectoryURL) {
            let asset = AVAsset(url: $0)

            completion(asset)
        }
    }
    
    private func export(composition: AVComposition, videoComposition: AVVideoComposition, outputURL: URL, completion: @escaping (URL) -> Void) {
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
    
}
