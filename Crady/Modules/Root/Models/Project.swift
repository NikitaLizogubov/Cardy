//
//  Project.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import UIKit
import AVFoundation

final class Project {
    let name: String
    let content: [Content]
    
    static let size: CGSize = CGSize(width: 1080.0, height: 1920.0)
    
    // MARK: - Init
    
    init(name: String, content: [Content]) {
        self.name = name
        self.content = content
    }
    
}

// MARK: - Mock

extension Project {
    
    static var mock: [Project] {
        [
            Project(
                name: "Template 1",
                content: [
                    Content(fragments: [
                        ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 40.0)),
                        TextFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 400.0 - 80.0), text: "Type here!"),
                        TextFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 800.0 - 120.0), text: "Type here!")
                    ], backgroundURL: Bundle.main.url(forResource: "background1", withExtension: ".jpeg")),
                    Content(fragments: [
                        ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 40.0)),
                        ImageFragment(position: CGPoint(x: 400.0 + 40.0, y: size.height - 400.0 - 80.0)),
                        ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 800.0 - 120.0)),
                        ImageFragment(position: CGPoint(x: 400.0 + 40.0, y: size.height - 1200.0 - 160.0))
                    ], backgroundURL: Bundle.main.url(forResource: "background2", withExtension: ".jpeg")),
                    Content(fragments: [
                        ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 40.0))
                    ], backgroundURL: Bundle.main.url(forResource: "background1", withExtension: ".jpeg")),
                ]
            )
        ]
    }
    
}
