//
//  ImageFragment.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 04.10.2022.
//

import UIKit

final class ImageFragment: Fragment {
    let position: CGPoint
    
    let borderWith: CGFloat
    let borderColor: UIColor
    
    var image: UIImage?
    
    init(position: CGPoint, borderWith: CGFloat = 8.0, borderColor: UIColor = .white) {
        self.position = position
        self.borderWith = borderWith
        self.borderColor = borderColor
    }
}
