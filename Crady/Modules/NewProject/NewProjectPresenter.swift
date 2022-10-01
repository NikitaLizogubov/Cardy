//
//  NewProjectPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit
import AVFoundation

protocol NewProjectPresenter {
    var navigationTitle: String { get }
    var previewButtonTitle: String { get }
    var numberOfItemsInSection: Int { get }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel
    func didPreview()
    
    var backgroundColor: UIColor { get }
}

final class NewProjectPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: NewProjectCoordinator
    private weak var view: NewProjectView?
    private let renderEngine: RenderEngine
    
    // Locale
    private var project: Project
    
    // MARK: - Init
    
    init(coordinator: NewProjectCoordinator, view: NewProjectView, renderEngine: RenderEngine) {
        self.coordinator = coordinator
        self.view = view
        self.renderEngine = renderEngine
        
        self.project = Project()
    }
    
}

// MARK: - NewProjectPresenter

extension NewProjectPresenterImpl: NewProjectPresenter {
    
    var navigationTitle: String {
        "!-!Template name"
    }
    
    var previewButtonTitle: String {
        "!-!Preview"
    }
    
    var numberOfItemsInSection: Int {
        3
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel {
        ProjectAssetTableViewCellViewModel(asset: project.images[indexPath.row]) { [unowned self] in
            coordinator.navigateToAssetPicker { (image) in
                guard let image = image else { return }
                
                project.images[indexPath.row] = image
                
                view?.reloadRow(for: indexPath)
            }
        }
    }
    
    func didPreview() {
        renderEngine.makePreviewAsset(project) { [unowned self] in
            guard let asset = $0 else { return }
            
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            
            coordinator.navigateToAssetPreview(with: player)
        }
    }
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}
