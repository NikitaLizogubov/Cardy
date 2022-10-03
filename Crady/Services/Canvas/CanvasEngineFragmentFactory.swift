//
//  CanvasEngineFragmentFactory.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 04.10.2022.
//

import UIKit

protocol CanvasEngineFragmentFactory {
    func make(frame: CGRect, fragment: Fragment) -> CALayer
}

struct CanvasEngineFragmentFactoryImpl { }

// MARK: - CanvasEngineFragmentFactory

extension CanvasEngineFragmentFactoryImpl: CanvasEngineFragmentFactory {
    
    func make(frame: CGRect, fragment: Fragment) -> CALayer {
        switch fragment {
        case let fragment as ImageFragment:
            let layer = CALayer()
            layer.frame = frame
            layer.contents = fragment.image?.cgImage
            layer.borderColor = fragment.borderColor.cgColor
            layer.borderWidth = fragment.borderWith
            return layer
        default:
            return CALayer()
        }
    }
    
}
