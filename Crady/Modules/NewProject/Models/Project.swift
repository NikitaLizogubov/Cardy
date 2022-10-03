//
//  Project.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

struct Project {
    
    // MARK: - Public properties
    
    let template: Template
    
    private(set) var images: [UIImage?]
    
    // MARK: - Init
    
    init(template: Template) {
        self.template = template
        self.images = Array(repeating: nil, count: template.imageFragments.count)
    }
    
    // MARK: - Public methods
    
    mutating func addImage(_ image: UIImage, for index: Int) {
        guard index >= .zero && index < images.count else { return }
        
        images[index] = image
    }
    
}
