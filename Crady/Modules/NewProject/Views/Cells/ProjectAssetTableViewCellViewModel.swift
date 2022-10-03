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

protocol ProjectAssetTableViewCellViewModelOutput {
    func didEdit()
}

typealias ProjectAssetTableViewCellViewModelType =
    ProjectAssetTableViewCellViewModelInput &
    ProjectAssetTableViewCellViewModelOutput

final class ProjectAssetTableViewCellViewModel: CollectionCellViewModel {
    
    // MARK: - Public properties
    
    var height: CGFloat {
        88.0
    }
    
    // MARK: - Private properties
    
    private let asset: UIImage?
    
    private let uploadHandler: () -> Void
    private let editHandler: () -> Void
    
    // MARK: - Init
    
    init(asset: UIImage?, uploadHandler: @escaping () -> Void, editHandler: @escaping () -> Void) {
        self.asset = asset
        self.uploadHandler = uploadHandler
        self.editHandler = editHandler
    }
    
    // MARK: - Public methods
    
    func didSelect() {
        uploadHandler()
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

// MARK: - ProjectAssetTableViewCellViewModelOutput

extension ProjectAssetTableViewCellViewModel: ProjectAssetTableViewCellViewModelOutput {
    
    func didEdit() {
        editHandler()
    }
    
}
