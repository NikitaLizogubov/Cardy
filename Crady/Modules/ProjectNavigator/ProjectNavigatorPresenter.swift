//
//  ProjectNavigatorPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import Foundation

protocol ProjectNavigatorPresenterInput {
    
}

protocol ProjectNavigatorPresenterOutput {
    
}

typealias ProjectNavigatorPresenter = ProjectNavigatorPresenterInput & ProjectNavigatorPresenterOutput

final class ProjectNavigatorPresenterImpl {
    
    // MARK: - Private properties
    
    // Injection
    private let coordinator: ProjectNavigatorCoordinator
    private weak var view: ProjectNavigatorView?
    
    init(coordinator: ProjectNavigatorCoordinator, view: ProjectNavigatorView) {
        self.coordinator = coordinator
        self.view = view
    }
    
}

// MARK: - ProjectNavigatorPresenterInput

extension ProjectNavigatorPresenterImpl: ProjectNavigatorPresenterInput {
    
}

// MARK: - ProjectNavigatorPresenterOutput

extension ProjectNavigatorPresenterImpl: ProjectNavigatorPresenterOutput {
    
}

