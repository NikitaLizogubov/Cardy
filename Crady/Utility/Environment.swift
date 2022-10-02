//
//  Environment.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import Foundation

struct Environment {
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
}
