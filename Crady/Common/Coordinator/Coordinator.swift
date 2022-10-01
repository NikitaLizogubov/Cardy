//
//  Coordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

class Coordinator {
    
    // MARK: - Public properties
    
    weak var viewController: UIViewController?
    weak var parentViewController: UIViewController?
    
    // MARK: - Init
    
    init(parentViewController: UIViewController?) {
        self.parentViewController = parentViewController
    }
    
    deinit {
        print("\(self) ---> ☠️")
    }
    
    // MARK: - Public methods
    
    func start() {
        fatalError("this \(#function) method must be overridden")
    }
    
}
