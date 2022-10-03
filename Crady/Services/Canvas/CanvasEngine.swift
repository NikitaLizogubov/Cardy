//
//  CanvasEngine.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit

protocol CanvasEngine {
    func makeCanvas(content: Content, completion: @escaping (UIImage?) -> Void)
}

final class CanvasEngineImpl {
    
    // MARK: - Private properties
    
    private let queue = DispatchQueue(label: "CanvasEngine.Cardy.com", qos: .userInitiated, attributes: [.concurrent])
    
    private let size: CGSize
    
    // MARK: - Init
    
    init(internalSize: CGSize) {
        self.size = internalSize
    }
    
}

// MARK: - CanvasEngine

extension CanvasEngineImpl: CanvasEngine {
    
    func makeCanvas(content: Content, completion: @escaping (UIImage?) -> Void) {
        queue.async {
            let rect = CGRect(origin: .zero, size: self.size)
            
            let mainLayer = CALayer()
            mainLayer.frame = rect
            mainLayer.backgroundColor = UIColor.black.cgColor
            
            let fragmentLayers = content.fragments.enumerated().map({ (index, fragment) in
                let position = fragment.position
                
                let point = CGPoint(x: self.size.width - position.x, y: self.size.height - position.y)
                let frame = CGRect(origin: point, size: CGSize(width: 400.0, height: 400.0))
                
                let layer = CALayer()
                layer.contents = (fragment as? ImageFragment)?.image?.cgImage
                layer.frame = frame
                layer.borderColor = fragment.borderColor.cgColor
                layer.borderWidth = fragment.borderWith
                return layer
            })
            
            mainLayer.addSublayers(fragmentLayers)
            
            let renderer = UIGraphicsImageRenderer(bounds: rect)
            let image = renderer.image {
                mainLayer.render(in: $0.cgContext)
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
}
