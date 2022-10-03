//
//  CanvasEngine.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit

protocol CanvasEngine {
    func makeCanvas(project: Project, completion: @escaping (UIImage?) -> Void)
}

final class CanvasEngineImpl {
    
    // MARK: - Private properties
    
    private let queue = DispatchQueue(label: "CanvasEngine.Cardy.com", qos: .userInitiated, attributes: [.concurrent])
    
}

// MARK: - CanvasEngine

extension CanvasEngineImpl: CanvasEngine {
    
    func makeCanvas(project: Project, completion: @escaping (UIImage?) -> Void) {
        queue.async {
            let size = project.template.size
            let rect = CGRect(origin: .zero, size: size)
            
            let imageLayers = project.images.enumerated().map({ (index, image) in
                let fragment = project.template.imageFragments[index]
                let position = fragment.position
                
                let point = CGPoint(x: size.width - position.x, y: size.height - position.y)
                let frame = CGRect(origin: point, size: CGSize(width: 400.0, height: 400.0))
                
                let imageLayer = CALayer()
                imageLayer.contents = image?.cgImage
                imageLayer.frame = frame
                imageLayer.borderColor = fragment.borderColor.cgColor
                imageLayer.borderWidth = fragment.borderWith
                return imageLayer
            })
            
            let mainLayer = CALayer()
            mainLayer.frame = rect
            mainLayer.backgroundColor = UIColor.black.cgColor
            
            mainLayer.addSublayers(imageLayers)
            
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
