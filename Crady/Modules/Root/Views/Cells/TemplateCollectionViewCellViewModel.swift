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
    
    
    
}

// MARK: - RootPresenter

extension TemplateCollectionViewCellViewModel: TemplateCollectionViewCellViewModelInput {
    
    var title: String {
        "+"
    }
    
    var backgroundColor: UIColor {
        .lightGray
    }
    
}
