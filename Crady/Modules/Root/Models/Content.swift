//
//  Content.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 04.10.2022.
//

import Foundation

final class Content {
    let fragments: [Fragment]
    
    let backgroundURL: URL?
    
    init(fragments: [Fragment], backgroundURL: URL?) {
        self.fragments = fragments
        self.backgroundURL = backgroundURL
    }
}
