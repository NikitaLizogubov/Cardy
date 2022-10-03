//
//  ProjectNavigatorCoordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit
import AVKit

protocol ProjectNavigatorCoordinator: AnyObject {
    func navigateToAssetPreview(with player: AVPlayer)
}

final class ProjectNavigatorCoordinatorImpl: Coordinator {
    
    // MARK: - Private properties
    
    private let project: Project
    
    // MARK: - Init
    
    init(project: Project, parentViewController: UIViewController?) {
        self.project = project
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let factory = ProjectFragmentEditorFactoryImp()
        let renderEngine = RenderEngineImpl()
        
        let viewController = ProjectNavigatorViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        let presenter = ProjectNavigatorPresenterImpl(coordinator: self, view: viewController, project: project, renderEngine: renderEngine)
        
        viewController.presenter = presenter
        viewController.setViewControllers(project.content.compactMap({
            factory.makeCoordinator(project: project, content: $0, parentViewController: parentViewController)?.generateModule()
        }))
        
        self.viewController = viewController
        
        (parentViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
}


// MARK: - ProjectNavigatorCoordinator

extension ProjectNavigatorCoordinatorImpl: ProjectNavigatorCoordinator {
    
    func navigateToAssetPreview(with player: AVPlayer) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        viewController?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
}
