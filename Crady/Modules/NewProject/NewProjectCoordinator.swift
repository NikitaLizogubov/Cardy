//
//  NewProjectCoordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit
import AVKit

protocol NewProjectCoordinator: AnyObject {
    func back()
    func navigateToAssetPicker(completion: @escaping (UIImage?) -> Void)
    func navigateToAssetPreview(with player: AVPlayer)
    func navigateToEditImage(_ image: UIImage)
}

final class NewProjectCoordinatorImpl: Coordinator {
    
    // MARK: - Private properties
    
    private let template: Template
    
    // MARK: - Init
    
    init(template: Template, parentViewController: UIViewController?) {
        self.template = template
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let viewController = NewProjectViewController()
        let canvasEngine = CanvasEngineImpl()
        let renderEngine = RenderEngineImpl()
        let presenter = NewProjectPresenterImpl(
            coordinator: self,
            view: viewController,
            template: template,
            canvasEngine: canvasEngine,
            renderEngine: renderEngine
        )
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
    
    func navigateToAssetPreview(with player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        viewController?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func navigateToEditImage(_ image: UIImage) {
        print(#function)
    }
    
}
