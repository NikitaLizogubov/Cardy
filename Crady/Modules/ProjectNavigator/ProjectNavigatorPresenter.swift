//
//  ProjectNavigatorPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit
import AVFoundation

protocol ProjectNavigatorPresenterInput {
    var navigationViewModel: NavigationViewModelType { get }
    var numberOfItemsInSection: Int { get }
    var cellViewModels: [CellViewModel] { get }
    var backgroundColor: UIColor { get }
    var assetContainerBackgroundColor: UIColor { get }
}

protocol ProjectNavigatorPresenterOutput {
    
}

typealias ProjectNavigatorPresenter = ProjectNavigatorPresenterInput & ProjectNavigatorPresenterOutput

final class ProjectNavigatorPresenterImpl {
    
    // MARK: - Public properties
    
    var cellViewModels: [CellViewModel] = []
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: ProjectNavigatorCoordinator
    private weak var view: ProjectNavigatorView?
    
    private var project: Project
    private var renderEngine: RenderEngine
    
    // Locale
    private let assets: [AssetEdit]
    
    // MARK: - Init
    
    init(coordinator: ProjectNavigatorCoordinator, view: ProjectNavigatorView, project: Project, renderEngine: RenderEngine) {
        self.coordinator = coordinator
        self.view = view
        self.project = project
        self.renderEngine = renderEngine
        
        self.assets = AssetEdit.allCases
        
        self.setupCellViewModels()
    }
    
    // MARK: - Private methods
    
    private func setupCellViewModels() {
        cellViewModels = assets.map({ model in
            AssetEditCollectionCellViewModel(model: model) { [weak self] in
                switch model {
                case .preview:
                    self?.preview()
                case .canvas:
                    return
                case .music:
                    return
                case .filter:
                    return
                case .speed:
                    return
                case .trim:
                    return
                case .text:
                    return
                }
            }
        })
    }
    
    private func preview() {
        renderEngine.makePreview(project) {
            guard let asset = $0 else { return }
            
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            
            self.coordinator.navigateToAssetPreview(with: player)
        }
    }
    
}

// MARK: - ProjectNavigatorPresenterInput

extension ProjectNavigatorPresenterImpl: ProjectNavigatorPresenterInput {
    
    var navigationViewModel: NavigationViewModelType {
        NavigationViewModel { [unowned self] in
            coordinator.back()
        }
    }
    
    var numberOfItemsInSection: Int {
        assets.count
    }
    
    var backgroundColor: UIColor {
        Resources.Colors.Common.black
    }
    
    var assetContainerBackgroundColor: UIColor {
        Resources.Colors.Common.grayIV
    }
    
}

// MARK: - ProjectNavigatorPresenterOutput

extension ProjectNavigatorPresenterImpl: ProjectNavigatorPresenterOutput {
    
    
    
}

