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
    
    private let selectionHandler: () -> Void
    
    // MARK: - Init
    
    init(selectionHandler: @escaping () -> Void) {
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
        "+"
    }
    
    var backgroundColor: UIColor {
        .lightGray
    }
    
}
