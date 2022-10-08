//
//  AssetCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

protocol AssetCellViewModelInputProtocol {
    var assetTypeImage: UIImage? { get }
    var assetTypeTintColor: UIColor { get }
    var assetTypeBackgroundColor: UIColor { get }
    
    var contentText: String { get }
    var assetContentBackgroundColor: UIColor { get }
    
    var backgroundColor: UIColor { get }
}

protocol AssetCellViewModelOutputProtocol {
    
}

typealias AssetCellViewModelType =
    AssetCellViewModelInputProtocol &
    AssetCellViewModelOutputProtocol
