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
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel?
}

typealias NewProjectPresenter = NewProjectPresenterInput & NewProjectPresenterOutput

final class NewProjectPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: NewProjectCoordinator
    private weak var view: NewProjectView?
    private let fragments: [Fragment]
    private let canvasEngine: CanvasEngine
    private let cellViewModelFactory: ProjectEditorCellViewModelFactory
    
    // MARK: - Init
    
    init(
        coordinator: NewProjectCoordinator,
        view: NewProjectView,
        fragments: [Fragment],
        canvasEngine: CanvasEngine,
        cellViewModelFactory: ProjectEditorCellViewModelFactory
    ) {
        self.coordinator = coordinator
        self.view = view
        self.fragments = fragments
        self.canvasEngine = canvasEngine
        self.cellViewModelFactory = cellViewModelFactory
    }
    
    // MARK: - Private methods
    
    private func updatePreview() {
        canvasEngine.makeCanvas(fragments: fragments) { [unowned self] in
            self.view?.update(previewImage: $0)
        }
    }
    
}

// MARK: - NewProjectPresenterInput

extension NewProjectPresenterImpl: NewProjectPresenterInput {
    
    var numberOfItemsInSection: Int {
        fragments.count
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
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel? {
        let index = indexPath.row
        let fragment = fragments[index]
        
        return cellViewModelFactory.make(fragment: fragment, for: index, with: self)
    }
    
}

// MARK: - ProjectEditorCellViewModelDelegate

extension NewProjectPresenterImpl: ProjectEditorCellViewModelDelegate {
    
    func didUpload(fragment: ImageFragment, for index: Int) {
        coordinator.navigateToAssetPicker { [self] (image) in
            guard let image = image else { return }

            fragment.image = image

            view?.reloadRow(for: IndexPath(row: index, section: .zero))

            updatePreview()
        }
    }
    
    func didEdit(fragment: ImageFragment) {
        guard let image = fragment.image else { return }

        coordinator.navigateToEditImage(image)
    }
    
}
