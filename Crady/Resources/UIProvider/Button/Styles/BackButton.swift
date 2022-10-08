//
//  BackButton.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class BackButton: UIButton {
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let style = ButtonStyle(
            title: "",
            image: Resources.Images.Common.back,
            imageInsets: .zero,
            tintColor: Resources.Colors.Common.white,
            cornerRadius: 4.0,
            borderWidth: 0.5,
            borderColor: Resources.Colors.Common.white
        )
        
        ButtonDecorator.decorate(button: self, style: style)
    }
    
}
