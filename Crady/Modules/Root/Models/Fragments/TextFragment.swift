//
//  TextFragment.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class TextFragment: Fragment {
    let position: CGPoint
    
    var text: String?
    var textColor: UIColor
    
    init(position: CGPoint, text: String? = nil, textColor: UIColor = .black) {
        self.position = position
        self.text = text
        self.textColor = textColor
    }
}
