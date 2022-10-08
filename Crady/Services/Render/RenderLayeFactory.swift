//
//  RanderLayeFactory.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02/10/2022.
//

import UIKit

protocol RenderLayeFactory {
    func makeFragmentLayer(fragment: Fragment, size: CGSize) -> CALayer
    func makeVideLayer(size: CGSize) -> CALayer
    func makeAnimationLayer(size: CGSize) -> CALayer
}

struct RenderLayeFactoryImpl {
    
    // MARK: - Private properties
    
    private let fragmentFactory: FragmentLayerFactory
    
    // MARK: - Init
    
    init(fragmentFactory: FragmentLayerFactory) {
        self.fragmentFactory = fragmentFactory
    }
    
}

// MARK: - RenderLayeFactory

extension RenderLayeFactoryImpl: RenderLayeFactory {
    
    func makeFragmentLayer(fragment: Fragment, size: CGSize) -> CALayer {
        let position = fragment.position
        
        let fragmentSize = CGSize(width: 400.0, height: 400.0)
        
        let point = CGPoint(x: abs(position.x - size.width), y: position.y - fragmentSize.height)
        let frame = CGRect(origin: point, size: fragmentSize)
        
        return fragmentFactory.make(frame: frame, fragment: fragment)
    }
    
    func makeVideLayer(size: CGSize) -> CALayer {
        let frame = CGRect(origin: .zero, size: size)
        
        let videoLayer = CALayer()
        videoLayer.frame = frame
        
        return videoLayer
    }
    
    func makeAnimationLayer(size: CGSize) -> CALayer {
        let frame = CGRect(origin: .zero, size: size)
        
        let animationLayer = CALayer()
        animationLayer.frame = frame
        
        return animationLayer
    }
    
}
