//
//  TemplateCollectionViewCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol TemplateCollectionViewCellViewModelInput {
    var title: String { get }
    var backgroundColor: UIColor { get }
}

typealias TemplateCollectionViewCellViewModelType = TemplateCollectionViewCellViewModelInput

final class TemplateCollectionViewCellViewModel: CellViewModel {
    
    // MARK: - Private properties
    
    private let project: Project
    private let selectionHandler: () -> Void
    
    // MARK: - Init
    
    init(project: Project, selectionHandler: @escaping () -> Void) {
        self.project = project
        self.selectionHandler = selectionHandler
    }
    
    // MARK: - Public methods
    
    func didSelect() {
        selectionHandler()
    }
    
}

// MARK: - TemplateCollectionViewCellViewModelInput

extension TemplateCollectionViewCellViewModel: TemplateCollectionViewCellViewModelInput {
    
    var title: String {
        project.name
    }
    
    var backgroundColor: UIColor {
        .lightGray
    }
    
}
