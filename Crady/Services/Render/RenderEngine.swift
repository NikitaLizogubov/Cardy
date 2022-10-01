//
//  RenderEngine.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import Foundation
import AVFoundation

protocol RenderEngine {
    func makePreviewAsset(_ project: Project, completion: @escaping (AVAsset?) -> Void)
}

final class RenderEngineImpl {
    
}

// MARK: - RenderEngine

extension RenderEngineImpl: RenderEngine {
    
    func makePreviewAsset(_ project: Project, completion: @escaping (AVAsset?) -> Void) {
        let images = project.images.compactMap({ $0 })
        
        let imageSettings = ImageConvector.makeVideoSettings(
            codec: AVVideoCodecType.h264.rawValue,
            width: images.first?.cgImage?.width ?? .zero,
            height: images.first?.cgImage?.height ?? .zero
        )
        let imageConvector = ImageConvector(videoSettings: imageSettings)
        
        imageConvector?.createMovieFrom(images: images) { (url) in
            let asset = AVAsset(url: url)
            
            completion(asset)
        }
        
//        let composition = AVMutableComposition()
//
//        guard
//            let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
//            let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        else {
//            return nil
//        }
//
//        return nil
    }
    
}
