//
//  ImageAssetTableViewCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class ImageAssetTableViewCellViewModel: CellViewModel {
    
    // MARK: - Private properties
    
    private let fragment: ImageFragment
    private let selectionHandler: () -> Void
    
    // MARK: - Init
    
    init(fragment: ImageFragment, selectionHandler: @escaping () -> Void) {
        self.fragment = fragment
        self.selectionHandler = selectionHandler
    }
    
    // MARK: - Public methods
    
    func didSelect() {
        selectionHandler()
    }
    
}

// MARK: - AssetCellViewModelInputProtocol

extension ImageAssetTableViewCellViewModel: AssetCellViewModelInputProtocol {
    
    var assetTypeImage: UIImage? {
        Resources.Images.Common.canvas
    }
    
    var assetTypeTintColor: UIColor {
        Resources.Colors.Common.white
    }
    
    var assetTypeBackgroundColor: UIColor {
        Resources.Colors.Common.grayII
    }
    
    var contentText: String {
        "!-!Some image here"
    }
    
    var assetContentBackgroundColor: UIColor {
        Resources.Colors.Common.delicatePink
    }
    
    var backgroundColor: UIColor {
        Resources.Colors.Common.black
    }
    
}

// MARK: - AssetCellViewModelOutputProtocol

extension ImageAssetTableViewCellViewModel: AssetCellViewModelOutputProtocol {
    
    
    
}
