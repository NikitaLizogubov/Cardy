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
}

final class NewProjectCoordinatorImpl: Coordinator {
    
    // MARK: - Private properties
    
    private let project: Project
    private let content: ImageContent
    
    // MARK: - Init
    
    init(project: Project, content: ImageContent, parentViewController: UIViewController?) {
        self.project = project
        self.content = content
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Public methods
    
    override func generateModule() -> UIViewController {
        let viewController = NewProjectViewController()
        let canvasEngine = CanvasEngineImpl(internalSize: project.size)
        let presenter = NewProjectPresenterImpl(
            coordinator: self,
            view: viewController,
            content: content,
            canvasEngine: canvasEngine
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
    
}
