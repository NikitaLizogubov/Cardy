//
//  NewProjectCoordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol NewProjectCoordinator: AnyObject {
    func back()
    func navigateToAssetPicker(completion: @escaping (UIImage?) -> Void)
}

final class NewProjectCoordinatorImpl: Coordinator {
    
    // MARK: - Override
    
    override func start() {
        let viewController = NewProjectViewController()
        let presenter = NewProjectPresenterImpl(coordinator: self, view: viewController)
        viewController.presenter = presenter
        
        self.viewController = viewController
        
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - RootCoordinator

extension NewProjectCoordinatorImpl: NewProjectCoordinator {
    
    func back() {
        (parentViewController as? UINavigationController)?.popViewController(animated: true)
    }
    
    func navigateToAssetPicker(completion: @escaping (UIImage?) -> Void) {
        let coordinator = AssetPickerCoordinatorImpl(sourceType: .photoLibrary, completion: completion, parentViewController: viewController)
        coordinator.start()
    }
    
}
