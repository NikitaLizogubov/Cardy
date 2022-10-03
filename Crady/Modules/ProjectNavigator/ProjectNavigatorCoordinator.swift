//
//  ProjectNavigatorCoordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit

protocol ProjectNavigatorCoordinator: AnyObject {
    
}

final class ProjectNavigatorCoordinatorImpl: Coordinator {
    
    // MARK: - Private properties
    
    private let template: Template
    
    // MARK: - Init
    
    init(template: Template, parentViewController: UIViewController?) {
        self.template = template
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewController = ProjectNavigatorViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        let presenter = ProjectNavigatorPresenterImpl(coordinator: self, view: viewController)
        
        viewController.presenter = presenter
        viewController.setViewControllers([
            NewProjectCoordinatorImpl(template: template, parentViewController: parentViewController).generateModule(),
            NewProjectCoordinatorImpl(template: template, parentViewController: parentViewController).generateModule(),
            NewProjectCoordinatorImpl(template: template, parentViewController: parentViewController).generateModule()
        ])
        
        self.viewController = viewController
        
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}


// MARK: - ProjectNavigatorCoordinator

extension ProjectNavigatorCoordinatorImpl: ProjectNavigatorCoordinator {
    
}
