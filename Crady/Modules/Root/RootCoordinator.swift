//
//  RootCoordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol RootCoordinator: AnyObject {
    func navigateToCreateNewProject(using project: Project)
}

final class RootCoordinatorImpl: Coordinator {
    
    // MARK: - Private properties
    
    private weak var window: UIWindow?
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        
        super.init(parentViewController: nil)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewController = RootViewController()
        let presenter = RootPresenterImpl(coordinator: self, view: viewController)
        viewController.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        self.viewController = navigationController
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}

// MARK: - RootCoordinator

extension RootCoordinatorImpl: RootCoordinator {
    
    func navigateToCreateNewProject(using project: Project) {
        let coordinator = ProjectNavigatorCoordinatorImpl(project: project, parentViewController: viewController)
        coordinator.start()
    }
    
}
