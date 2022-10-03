//
//  CanvasEngine.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit

protocol CanvasEngine {
    func makeCanvas(fragments: [Fragment], completion: @escaping (UIImage?) -> Void)
}

final class CanvasEngineImpl {
    
    // MARK: - Private properties
    
    private let queue = DispatchQueue(label: "CanvasEngine.Cardy.com", qos: .userInitiated, attributes: [.concurrent])
    
    private let size: CGSize
    private let fragmentFactory: CanvasEngineFragmentFactory
    
    // MARK: - Init
    
    init(internalSize: CGSize, fragmentFactory: CanvasEngineFragmentFactory = CanvasEngineFragmentFactoryImpl()) {
        self.size = internalSize
        self.fragmentFactory = fragmentFactory
    }
    
}

// MARK: - CanvasEngine

extension CanvasEngineImpl: CanvasEngine {
    
    func makeCanvas(fragments: [Fragment], completion: @escaping (UIImage?) -> Void) {
        queue.async { [size, fragmentFactory] in
            let rect = CGRect(origin: .zero, size: size)
            
            let mainLayer = CALayer()
            mainLayer.frame = rect
            mainLayer.backgroundColor = UIColor.black.cgColor
            
            let fragmentLayers = fragments.enumerated().map({ (index, fragment) in
                let position = fragment.position
                
                let point = CGPoint(x: size.width - position.x, y: size.height - position.y)
                let frame = CGRect(origin: point, size: CGSize(width: 400.0, height: 400.0))
                
                return fragmentFactory.make(frame: frame, fragment: fragment)
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
