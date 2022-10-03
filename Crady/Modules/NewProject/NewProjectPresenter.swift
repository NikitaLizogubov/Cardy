//
//  NewProjectPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit
import AVFoundation

protocol NewProjectPresenterInput {
    var navigationTitle: String { get }
    var previewButtonTitle: String { get }
    var numberOfItemsInSection: Int { get }
    var backgroundColor: UIColor { get }
}

protocol NewProjectPresenterOutput {
    func viewDidLoad()
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel
    func didPreview()
}

typealias NewProjectPresenter = NewProjectPresenterInput & NewProjectPresenterOutput

final class NewProjectPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: NewProjectCoordinator
    private weak var view: NewProjectView?
    
    private let canvasEngine: CanvasEngine
    private let renderEngine: RenderEngine
    
    // Locale
    private var project: Project
    
    // MARK: - Init
    
    init(
        coordinator: NewProjectCoordinator,
        view: NewProjectView,
        template: Template,
        canvasEngine: CanvasEngine,
        renderEngine: RenderEngine
    ) {
        self.coordinator = coordinator
        self.view = view
        self.canvasEngine = canvasEngine
        self.renderEngine = renderEngine
        
        self.project = Project(template: template)
    }
    
    // MARK: - Private methods
    
    private func updatePreview() {
        canvasEngine.makeCanvas(project: project) { [unowned self] in
            self.view?.update(previewImage: $0)
        }
    }
    
}

// MARK: - NewProjectPresenterInput

extension NewProjectPresenterImpl: NewProjectPresenterInput {
    
    var navigationTitle: String {
        project.template.name
    }
    
    var previewButtonTitle: String {
        "!-!Preview"
    }
    
    var numberOfItemsInSection: Int {
        project.template.imageFragments.count
    }
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}

// MARK: - NewProjectPresenterOutput

extension NewProjectPresenterImpl: NewProjectPresenterOutput {
    
    func viewDidLoad() {
        updatePreview()
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel {
        ProjectAssetTableViewCellViewModel(asset: project.images[indexPath.row], uploadHandler: { [unowned self] in
            coordinator.navigateToAssetPicker { (image) in
                guard let image = image else { return }
                
                self.project.addImage(image, for: indexPath.row)
                
                self.view?.reloadRow(for: indexPath)
                
                self.updatePreview()
            }
        }, editHandler: { [unowned self] in
            guard let image = project.images[indexPath.row] else { return }
            
            self.coordinator.navigateToEditImage(image)
        })
    }
    
    func didPreview() {
        view?.startLoading()
        
        renderEngine.makePreviewAsset(project) { [self] in
            guard let asset = $0 else { return }
            
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            
            coordinator.navigateToAssetPreview(with: player)
            
            view?.stopLoading()
        }
    }
    
}
