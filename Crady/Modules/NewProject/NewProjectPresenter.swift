//
//  NewProjectPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol NewProjectPresenter {
    var navigationTitle: String { get }
    var numberOfItemsInSection: Int { get }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel
    
    var backgroundColor: UIColor { get }
}

final class NewProjectPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: NewProjectCoordinator
    private weak var view: NewProjectView?
    
    // Locale
    private var project: Project
    
    // MARK: - Init
    
    init(coordinator: NewProjectCoordinator, view: NewProjectView) {
        self.coordinator = coordinator
        self.view = view
        
        self.project = Project()
    }
    
}

// MARK: - NewProjectPresenter

extension NewProjectPresenterImpl: NewProjectPresenter {
    
    var navigationTitle: String {
        "!-!Template name"
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
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}
