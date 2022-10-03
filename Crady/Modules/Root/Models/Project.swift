//
//  Project.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import UIKit
import AVFoundation

protocol Content {
    var fragments: [Fragment] { get }
    
    var backgroundURL: URL? { get }
}

protocol Fragment {
    var position: CGPoint { get }
    
    var borderWith: CGFloat  { get }
    var borderColor: UIColor  { get }
}

class ImageContent: Content {
    let fragments: [Fragment]
    
    let backgroundURL: URL?
    
    init(fragments: [Fragment], backgroundURL: URL?) {
        self.fragments = fragments
        self.backgroundURL = backgroundURL
    }
    
    func image(for index: Int) -> UIImage? {
        (fragments[index] as? ImageFragment)?.image
    }
    
    func addImage(_ image: UIImage, for index: Int) {
        (fragments[index] as? ImageFragment)?.image = image
    }
}

class ImageFragment: Fragment {
    let position: CGPoint
    
    let borderWith: CGFloat = 8.0
    let borderColor: UIColor = .white
    
    var image: UIImage?
    
    init(position: CGPoint) {
        self.position = position
    }
}

class Project {
    let name: String
    let content: [Content]
    
    let size: CGSize = CGSize(width: 1080.0, height: 1920.0)
    
    // MARK: - Init
    
    init(name: String, content: [Content]) {
        self.name = name
        self.content = content
    }
    
    // MARK: - Mock
    
    static var mock: [Project] {
        let size: CGSize = CGSize(width: 1080.0, height: 1920.0)
        
        return [
            Project(
                name: "Template 1",
                content: [
                    ImageContent(fragments: [
                        ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 40.0)),
                        ImageFragment(position: CGPoint(x: 400.0 + 40.0, y: size.height - 400.0 - 80.0)),
                        ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 800.0 - 120.0)),
                        ImageFragment(position: CGPoint(x: 400.0 + 40.0, y: size.height - 1200.0 - 160.0))
                    ], backgroundURL: Bundle.main.url(forResource: "background1", withExtension: ".mp4")),
                    ImageContent(fragments: [
                        ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 40.0))
                    ], backgroundURL: Bundle.main.url(forResource: "background2", withExtension: ".mp4")),
                    ImageContent(fragments: [
                        ImageFragment(position: CGPoint(x: 400.0 + 40.0, y: size.height - 1200.0 - 160.0))
                    ], backgroundURL: Bundle.main.url(forResource: "background3", withExtension: ".mp4"))
                ]
            )
        ]
    }
}
