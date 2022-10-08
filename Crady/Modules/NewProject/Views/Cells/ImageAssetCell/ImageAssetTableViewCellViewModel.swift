//
//  ImageAssetTableViewCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol ImageAssetTableViewCellViewModelInput {
    var assetPreviewImage: UIImage? { get }
    var assetTitle: String { get }
}

protocol ImageAssetTableViewCellViewModelOutput {
    func didEdit()
    func didRemove()
}

typealias ImageAssetTableViewCellViewModelType =
    ImageAssetTableViewCellViewModelInput &
    ImageAssetTableViewCellViewModelOutput

final class ImageAssetTableViewCellViewModel: CollectionCellViewModel {
    
    // MARK: - Public properties
    
    var height: CGFloat {
        88.0
    }
    
    // MARK: - Private properties
    
    private let asset: UIImage?
    
    private let uploadHandler: () -> Void
    private let editHandler: () -> Void
    private let removeHandler: () -> Void
    
    // MARK: - Init
    
    init(asset: UIImage?, uploadHandler: @escaping () -> Void, editHandler: @escaping () -> Void, removeHandler: @escaping () -> Void) {
        self.asset = asset
        self.uploadHandler = uploadHandler
        self.editHandler = editHandler
        self.removeHandler = removeHandler
    }
    
    // MARK: - Public methods
    
    func didSelect() {
        uploadHandler()
    }
    
}

// MARK: - ImageAssetTableViewCellViewModelInput

extension ImageAssetTableViewCellViewModel: ImageAssetTableViewCellViewModelInput {
    
    var assetPreviewImage: UIImage? {
        asset ?? .add
    }
    
    var assetTitle: String {
        "!-!Asset title"
    }
    
}

// MARK: - ImageAssetTableViewCellViewModelOutput

extension ImageAssetTableViewCellViewModel: ImageAssetTableViewCellViewModelOutput {
    
    func didEdit() {
        editHandler()
    }
    
    func didRemove() {
        removeHandler()
    }
    
}
