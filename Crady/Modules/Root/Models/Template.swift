//
//  Template.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import Foundation
import AVFoundation

struct Template {
    let name: String
    let backgroundURL: URL?
    
    var asset: AVAsset? {
        guard let url = backgroundURL else { return nil }

        return AVAsset(url: url)
    }
    
    static var mock: [Template] {
        [
            Template(name: "Template 1", backgroundURL: Bundle.main.url(forResource: "background1", withExtension: ".mp4")),
            Template(name: "Template 2", backgroundURL: Bundle.main.url(forResource: "background2", withExtension: ".mp4")),
            Template(name: "Template 3", backgroundURL: Bundle.main.url(forResource: "background3", withExtension: ".mp4"))
        ]
    }
}
