//
//  CALayer+addSublayes.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02/10/2022.
//

import UIKit

extension CALayer {
    
    func addSublayers(_ sublayers: [CALayer]) {
        sublayers.forEach({
            addSublayer($0)
        })
    }
    
}
