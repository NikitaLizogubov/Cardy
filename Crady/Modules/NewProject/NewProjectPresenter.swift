//
//  NewProjectPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit
import AVFoundation

protocol NewProjectPresenterInput {
    var numberOfItemsInSection: Int { get }
    var backgroundColor: UIColor { get }
}

protocol NewProjectPresenterOutput {
    func viewDidLoad()
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel
}

typealias NewProjectPresenter = NewProjectPresenterInput & NewProjectPresenterOutput

final class NewProjectPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: NewProjectCoordinator
    private weak var view: NewProjectView?
    
    private let canvasEngine: CanvasEngine
    
    private let content: ImageContent
    
    // MARK: - Init
    
    init(
        coordinator: NewProjectCoordinator,
        view: NewProjectView,
        content: ImageContent,
        canvasEngine: CanvasEngine
    ) {
        self.coordinator = coordinator
        self.view = view
        self.canvasEngine = canvasEngine
        self.content = content
    }
    
    // MARK: - Private methods
    
    private func updatePreview() {
        canvasEngine.makeCanvas(content: content) { [unowned self] in
            self.view?.update(previewImage: $0)
        }
    }
    
}

// MARK: - NewProjectPresenterInput

extension NewProjectPresenterImpl: NewProjectPresenterInput {
    
    var numberOfItemsInSection: Int {
        content.fragments.count
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
        ProjectAssetTableViewCellViewModel(asset: content.image(for: indexPath.row), uploadHandler: { [unowned self] in
            coordinator.navigateToAssetPicker { (image) in
                guard let image = image else { return }

                self.content.addImage(image, for: indexPath.row)

                self.view?.reloadRow(for: indexPath)

                self.updatePreview()
            }
        }, editHandler: { [unowned self] in
            guard let image = self.content.image(for: indexPath.row) else { return }
            
            self.coordinator.navigateToEditImage(image)
        })
    }
    
}
