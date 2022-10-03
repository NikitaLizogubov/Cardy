//
//  ProjectNavigatorPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit
import AVFoundation

protocol ProjectNavigatorPresenterInput {
    var navigationTitle: String { get }
    var previewButtonTitle: String { get }
    var backgroundColor: UIColor { get }
}

protocol ProjectNavigatorPresenterOutput {
    func didPreview()
}

typealias ProjectNavigatorPresenter = ProjectNavigatorPresenterInput & ProjectNavigatorPresenterOutput

final class ProjectNavigatorPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: ProjectNavigatorCoordinator
    private weak var view: ProjectNavigatorView?
    
    private var project: Project
    private var renderEngine: RenderEngine
    
    // MARK: - Init
    
    init(coordinator: ProjectNavigatorCoordinator, view: ProjectNavigatorView, project: Project, renderEngine: RenderEngine) {
        self.coordinator = coordinator
        self.view = view
        self.project = project
        self.renderEngine = renderEngine
    }
    
}

// MARK: - ProjectNavigatorPresenterInput

extension ProjectNavigatorPresenterImpl: ProjectNavigatorPresenterInput {
    
    var navigationTitle: String {
        project.name
    }
    
    var previewButtonTitle: String {
        "!-!Preview"
    }
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}

// MARK: - ProjectNavigatorPresenterOutput

extension ProjectNavigatorPresenterImpl: ProjectNavigatorPresenterOutput {
    
    func didPreview() {
//        view?.startLoading()

        renderEngine.makePreviewAsset(project) { [self] in
            guard let asset = $0 else { return }

            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)

            coordinator.navigateToAssetPreview(with: player)

//            view?.stopLoading()
        }
    }
    
}

