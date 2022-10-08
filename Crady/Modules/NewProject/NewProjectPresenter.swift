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
    func cellViewModel(for indexPath: IndexPath) -> CellViewModel?
}

typealias NewProjectPresenter = NewProjectPresenterInput & NewProjectPresenterOutput

final class NewProjectPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: NewProjectCoordinator
    private weak var view: NewProjectView?
    private let content: Content
    private let canvasEngine: CanvasEngine
    private let cellViewModelFactory: ProjectEditorCellViewModelFactory
    
    // MARK: - Init
    
    init(
        coordinator: NewProjectCoordinator,
        view: NewProjectView,
        content: Content,
        canvasEngine: CanvasEngine,
        cellViewModelFactory: ProjectEditorCellViewModelFactory
    ) {
        self.coordinator = coordinator
        self.view = view
        self.content = content
        self.canvasEngine = canvasEngine
        self.cellViewModelFactory = cellViewModelFactory
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
        .black
    }
    
}

// MARK: - NewProjectPresenterOutput

extension NewProjectPresenterImpl: NewProjectPresenterOutput {
    
    func viewDidLoad() {
        updatePreview()
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CellViewModel? {
        let index = indexPath.row
        let fragment = content.fragments[index]
        
        return cellViewModelFactory.make(fragment: fragment, for: index, with: self)
    }
    
}

// MARK: - ProjectEditorCellViewModelDelegate

extension NewProjectPresenterImpl: ProjectEditorCellViewModelDelegate {
    
    func didEdit(fragment: ImageFragment, for index: Int) {
        coordinator.navigateToAssetPicker { [self] (image) in
            guard let image = image else { return }

            fragment.image = image

            view?.reloadRow(for: IndexPath(row: index, section: .zero))

            updatePreview()
        }
    }
    
    func didEdit(fragment: TextFragment, for index: Int) {
        coordinator.navigateToEditText(fragment.text ?? "") { [self] (text) in
            fragment.text = text
            
            view?.reloadRow(for: IndexPath(row: index, section: .zero))

            updatePreview()
        }
    }
    
}
