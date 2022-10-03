//
//  RootPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol RootPresenter {
    var navigationTitle: String { get }
    var numberOfItemsInSection: Int { get }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel
    
    var backgroundColor: UIColor { get }
}

final class RootPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: RootCoordinator
    private weak var view: RootView?
    
    // Locale
    private let project: [Project]
    
    // MARK: - Init
    
    init(coordinator: RootCoordinator, view: RootView) {
        self.coordinator = coordinator
        self.view = view
        
        self.project = Project.mock
    }
    
}

// MARK: - RootPresenter

extension RootPresenterImpl: RootPresenter {
    
    var navigationTitle: String {
        "!-!Templates"
    }
    
    var numberOfItemsInSection: Int {
        project.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionCellViewModel {
        TemplateCollectionViewCellViewModel(project: project[indexPath.row]) { [unowned self] in
            coordinator.navigateToCreateNewProject(using: project[indexPath.row])
        }
    }
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}
