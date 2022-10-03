//
//  Template.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import UIKit
import AVFoundation

struct ImageFragment {
    let position: CGPoint
    
    let borderWith: CGFloat = 8.0
    let borderColor: UIColor = .white
}

struct Template {
    let name: String
    let backgroundURL: URL?
    let imageFragments: [ImageFragment]
    
    let size: CGSize = CGSize(width: 1080.0, height: 1920.0)
    
    var asset: AVAsset? {
        guard let url = backgroundURL else { return nil }

        return AVAsset(url: url)
    }
    
    static var mock: [Template] {
        let size: CGSize = CGSize(width: 1080.0, height: 1920.0)
        
        return [
            Template(
                name: "Template 1",
                backgroundURL: Bundle.main.url(forResource: "background1", withExtension: ".mp4"),
                imageFragments: [
                    ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 40.0)),
                    ImageFragment(position: CGPoint(x: 400.0 + 40.0, y: size.height - 400.0 - 80.0)),
                    ImageFragment(position: CGPoint(x: size.width - 40.0, y: size.height - 800.0 - 120.0)),
                    ImageFragment(position: CGPoint(x: 400.0 + 40.0, y: size.height - 1200.0 - 160.0))
                ]
            ),
            Template(
                name: "Template 2",
                backgroundURL: Bundle.main.url(forResource: "background2", withExtension: ".mp4"),
                imageFragments: [
                    ImageFragment(position: .zero),
                    ImageFragment(position: CGPoint(x: 400.0, y: 400.0)),
                    ImageFragment(position: CGPoint(x: .zero, y: 800.0))
                ]
            ),
            Template(
                name: "Template 3",
                backgroundURL: Bundle.main.url(forResource: "background3", withExtension: ".mp4"),
                imageFragments: [
                    ImageFragment(position: .zero),
                    ImageFragment(position: CGPoint(x: 400.0, y: 400.0)),
                    ImageFragment(position: CGPoint(x: .zero, y: 800.0))
                ]
            )
        ]
    }
}
