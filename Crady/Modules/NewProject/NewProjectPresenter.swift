//
//  NewProjectPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol NewProjectPresenter {
    var backgroundColor: UIColor { get }
}

final class NewProjectPresenterImpl {
    
    // MARK: - Private properties
    
    private let coordinator: NewProjectCoordinator
    private weak var view: NewProjectView?
    
    // MARK: - Init
    
    init(coordinator: NewProjectCoordinator, view: NewProjectView) {
        self.coordinator = coordinator
        self.view = view
    }
    
}

// MARK: - RootPresenter

extension NewProjectPresenterImpl: NewProjectPresenter {
    
    var backgroundColor: UIColor {
        .systemBackground
    }
    
}
