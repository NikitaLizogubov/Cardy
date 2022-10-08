//
//  UIView+roundCorners.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

extension UIView {
    
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       
        let mask = CAShapeLayer()
        mask.path = path.cgPath
       
        layer.mask = mask
    }
    
}
