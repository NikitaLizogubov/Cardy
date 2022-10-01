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
    
    func cellViewModel(for: IndexPath) -> CollectionCellViewModel
    
    var backgroundColor: UIColor { get }
}

final class RootPresenterImpl {
    
    // MARK: - Private properties
    
    private let coordinator: RootCoordinator
    private weak var view: RootView?
    
    // MARK: - Init
    
    init(coordinator: RootCoordinator, view: RootView) {
        self.coordinator = coordinator
        self.view = view
    }
    
}

// MARK: - RootPresenter

extension RootPresenterImpl: RootPresenter {
    
    var navigationTitle: String {
        "!-!Templates"
    }
    
    var numberOfItemsInSection: Int {
        1
    }
    
    func cellViewModel(for: IndexPath) -> CollectionCellViewModel {
        TemplateCollectionViewCellViewModel { [unowned self] in
            coordinator.navigateToCreateNewProject()
        }
    }
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}
