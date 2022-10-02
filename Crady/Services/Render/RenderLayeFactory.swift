//
//  RanderLayeFactory.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02/10/2022.
//

import UIKit
import AVFoundation

protocol RenderLayeFactory {
    func makeImageLayers(_ images: [UIImage], positions: [CGPoint], for track: AVMutableCompositionTrack) -> [CALayer]
    func makeVideLayer(for track: AVMutableCompositionTrack) -> CALayer
    func makeAnimationLayer(for track: AVMutableCompositionTrack) -> CALayer
}

struct RenderLayeFactoryImpl { }

// MARK: - RenderLayeFactory

extension RenderLayeFactoryImpl: RenderLayeFactory {
    
    func makeImageLayers(_ images: [UIImage], positions: [CGPoint], for track: AVMutableCompositionTrack) -> [CALayer] {
        images.enumerated().map({ (index, image) in
            let frame = CGRect(origin: positions[index], size: CGSize(width: 400.0, height: 400.0)) 
            
            let imageLayer = CALayer()
            imageLayer.contents = image.cgImage
            imageLayer.frame = frame
            return imageLayer
        })
    }
    
    func makeVideLayer(for track: AVMutableCompositionTrack) -> CALayer {
        let frame = CGRect(origin: .zero, size: track.naturalSize)
        
        let videoLayer = CALayer()
        videoLayer.frame = frame
        
        return videoLayer
    }
    
    func makeAnimationLayer(for track: AVMutableCompositionTrack) -> CALayer {
        let frame = CGRect(origin: .zero, size: track.naturalSize)
        
        let animationLayer = CALayer()
        animationLayer.frame = frame
        
        return animationLayer
    }
    
}
