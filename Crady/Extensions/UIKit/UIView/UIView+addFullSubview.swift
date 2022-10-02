//
//  UIView+addFullSubview.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02/10/2022.
//

import UIKit

extension UIView {
    
    func addFullSubview(_ view: UIView, _ insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right)
        ])
    }
    
}
