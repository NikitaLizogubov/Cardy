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
    func navigateToEditImage(_ image: UIImage)
    func navigateToEditText(_ text: String, completion: @escaping (String?) -> Void)
}

final class NewProjectCoordinatorImpl: Coordinator {
    
    // MARK: - Private properties
    
    private let dependency: ProjectEntityDependency
    
    // MARK: - Init
    
    init(dependency: ProjectEntityDependency, parentViewController: UIViewController?) {
        self.dependency = dependency
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Public methods
    
    override func generateModule() -> UIViewController {
        let viewController = NewProjectViewController()
        let presenter = NewProjectPresenterImpl(
            coordinator: self,
            view: viewController,
            content: dependency.content,
            canvasEngine: dependency.canvasEngine,
            cellViewModelFactory: dependency.cellViewModelFactory
        )
        viewController.presenter = presenter
        
        self.viewController = viewController
        
        return viewController
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
    
    func navigateToEditImage(_ image: UIImage) {
        print(#function)
    }
    
    func navigateToEditText(_ text: String, completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = text
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            
            completion(textField.text)
        }))

        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
