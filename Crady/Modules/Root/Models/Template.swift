//
//  Template.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import Foundation
import AVFoundation

struct ImageFragment {
    let position: CGPoint
}

struct Template {
    let name: String
    let backgroundURL: URL?
    let imageFragments: [ImageFragment]
    
    var asset: AVAsset? {
        guard let url = backgroundURL else { return nil }

        return AVAsset(url: url)
    }
    
    static var mock: [Template] {
        [
            Template(
                name: "Template 1",
                backgroundURL: Bundle.main.url(forResource: "background1", withExtension: ".mp4"),
                imageFragments: [
                    ImageFragment(position: CGPoint(x: 1040.0, y: 440.0)),
                    ImageFragment(position: CGPoint(x: 800.0, y: 840.0)),
                    ImageFragment(position: CGPoint(x: 1040.0, y: 1200.0))
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
