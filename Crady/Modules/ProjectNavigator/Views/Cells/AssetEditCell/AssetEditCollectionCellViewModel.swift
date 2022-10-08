//
//  AssetEditCollectionCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

protocol AssetEditCollectionCellViewModelInput {
    var image: UIImage? { get }
    var title: String { get }
    
    var tintColor: UIColor { get }
    var backgroundColor: UIColor { get }
}

typealias AssetEditCollectionCellViewModelType = AssetEditCollectionCellViewModelInput

final class AssetEditCollectionCellViewModel: CellViewModel {
    
    // MARK: - Private properties
    
    private let model: AssetEdit
    private let selectionHandler: () -> Void
    
    // MARK: - Init
    
    init(model: AssetEdit, selectionHandler: @escaping () -> Void) {
        self.model = model
        self.selectionHandler = selectionHandler
    }
    
    // MARK: - Public methods
    
    func didSelect() {
        selectionHandler()
    }
    
}

// MARK: - AssetEditCollectionCellViewModelInput

extension AssetEditCollectionCellViewModel: AssetEditCollectionCellViewModelInput {
    
    var image: UIImage? {
        model.image
    }
    
    var title: String {
        model.text
    }
    
    var tintColor: UIColor {
        model.tintColor
    }
    
    var backgroundColor: UIColor {
        model.backgroundColor
    }
    
}
