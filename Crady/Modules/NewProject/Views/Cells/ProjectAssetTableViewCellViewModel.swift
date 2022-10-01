//
//  ProjectAssetTableViewCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol ProjectAssetTableViewCellViewModelInput {
    var assetPreviewImage: UIImage? { get }
    var assetTitle: String { get }
}

typealias ProjectAssetTableViewCellViewModelType = ProjectAssetTableViewCellViewModelInput

final class ProjectAssetTableViewCellViewModel: CollectionCellViewModel {
    
    // MARK: - Public properties
    
    var height: CGFloat {
        88.0
    }
    
    // MARK: - Private properties
    
    private let asset: UIImage?
    private let selectionHandler: () -> Void
    
    // MARK: - Init
    
    init(asset: UIImage?, selectionHandler: @escaping () -> Void) {
        self.asset = asset
        self.selectionHandler = selectionHandler
    }
    
    // MARK: - Public methods
    
    func didSelect() {
        selectionHandler()
    }
    
}

// MARK: - ProjectAssetTableViewCellViewModelInput

extension ProjectAssetTableViewCellViewModel: ProjectAssetTableViewCellViewModelInput {
    
    var assetPreviewImage: UIImage? {
        asset ?? .add
    }
    
    var assetTitle: String {
        "!-!Asset title"
    }
    
}
