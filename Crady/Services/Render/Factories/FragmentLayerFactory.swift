//
//  FragmentLayerFactory.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 04.10.2022.
//

import UIKit

protocol FragmentLayerFactory {
    func make(frame: CGRect, fragment: Fragment) -> CALayer
}

struct FragmentLayerFactoryImpl { }

// MARK: - CanvasEngineFragmentFactory

extension FragmentLayerFactoryImpl: FragmentLayerFactory {
    
    func make(frame: CGRect, fragment: Fragment) -> CALayer {
        switch fragment {
        case let fragment as ImageFragment:
            let layer = CALayer()
            layer.frame = frame
            layer.contents = fragment.image?.cgImage
            layer.borderColor = fragment.borderColor.cgColor
            layer.borderWidth = fragment.borderWith
            return layer
        case let fragment as TextFragment:
            let layer = CATextLayer()
            layer.frame = frame
            layer.string = fragment.text
            layer.foregroundColor = fragment.textColor.cgColor
            return layer
        default:
            return CALayer()
        }
    }
    
}
