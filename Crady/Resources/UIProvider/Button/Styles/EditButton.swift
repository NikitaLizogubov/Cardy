//
//  EditButton.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class EditButton: UIButton {
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let style = ButtonStyle(
            title: "",
            image: Resources.Images.Common.edit,
            imageInsets: .zero,
            tintColor: Resources.Colors.Common.black,
            cornerRadius: .zero,
            borderWidth: .zero,
            borderColor: nil
        )
        
        ButtonDecorator.decorate(button: self, style: style)
    }
    
}
