//
//  TextAssetTableViewCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class TextAssetTableViewCellViewModel: CellViewModel {
    
    // MARK: - Private properties
    
    private let fragment: TextFragment
    private let selectionHandler: () -> Void
    
    // MARK: - Init
    
    init(fragment: TextFragment, selectionHandler: @escaping () -> Void) {
        self.fragment = fragment
        self.selectionHandler = selectionHandler
    }
    
    // MARK: - Public methods
    
    func didSelect() {
        selectionHandler()
    }
    
}

// MARK: - AssetCellViewModelInputProtocol

extension TextAssetTableViewCellViewModel: AssetCellViewModelInputProtocol {
    
    var assetTypeImage: UIImage? {
        Resources.Images.Common.text
    }
    
    var assetTypeTintColor: UIColor {
        Resources.Colors.Common.white
    }
    
    var assetTypeBackgroundColor: UIColor {
        Resources.Colors.Common.grayII
    }
    
    var contentText: String {
        fragment.text ?? "!-!Type here"
    }
    
    var assetContentBackgroundColor: UIColor {
        Resources.Colors.Common.aquamarine
    }
    
    var backgroundColor: UIColor {
        Resources.Colors.Common.black
    }
    
}

// MARK: - AssetCellViewModelOutputProtocol

extension TextAssetTableViewCellViewModel: AssetCellViewModelOutputProtocol {
    
    
    
}
