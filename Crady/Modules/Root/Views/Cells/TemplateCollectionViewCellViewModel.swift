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

final class TemplateCollectionViewCellViewModel: CollectionCellViewModel {
    
    // MARK: - Private properties
    
    private let template: Template
    private let selectionHandler: () -> Void
    
    // MARK: - Init
    
    init(template: Template, selectionHandler: @escaping () -> Void) {
        self.template = template
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
        template.name
    }
    
    var backgroundColor: UIColor {
        .lightGray
    }
    
}
