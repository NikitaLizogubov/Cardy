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
    var cellViewModels: [CellViewModel] { get }
    var backgroundColor: UIColor { get }
}

final class RootPresenterImpl {
    
    // MARK: - Public properties
    
    var cellViewModels: [CellViewModel] = []
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: RootCoordinator
    private weak var view: RootView?
    
    // Locale
    private let projects: [Project]
    
    // MARK: - Init
    
    init(coordinator: RootCoordinator, view: RootView) {
        self.coordinator = coordinator
        self.view = view
        
        self.projects = Project.mock
        
        self.setupCellViewModels()
    }
    
    // MARK: - Private methods
    
    private func setupCellViewModels() {
        cellViewModels = projects.map({ project in
            TemplateCollectionViewCellViewModel(project: project) { [unowned self] in
                coordinator.navigateToCreateNewProject(using: project)
            }
        })
    }
    
}

// MARK: - RootPresenter

extension RootPresenterImpl: RootPresenter {
    
    var navigationTitle: String {
        "!-!Templates"
    }
    
    var numberOfItemsInSection: Int {
        projects.count
    }
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}
