//
//  ButtonDecorator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

struct ButtonDecorator {
    
    static func decorate(button: UIButton, style: ButtonStyle) {
        button.setTitle(style.title, for: .normal)
        
        button.setImage(style.image, for: .normal)
        button.imageEdgeInsets = style.imageInsets
        button.tintColor = style.tintColor
        
        button.layer.cornerRadius = style.cornerRadius
        button.layer.borderWidth = style.borderWidth
        button.layer.borderColor = style.borderColor?.cgColor
    }
    
}
