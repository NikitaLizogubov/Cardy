//
//  RootCoordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

final class RootCoordinator: Coordinator {
    
    // MARK: - Private properties
    
    private weak var window: UIWindow?
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        
        super.init(parentViewController: nil)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        
        self.viewController = viewController
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
}
