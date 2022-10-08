//
//  AssetTableViewCell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class AssetTableViewCell: UITableViewCell, Cell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var assetTypeContainerView: UIView!
    @IBOutlet private weak var assetTypeImageView: UIImageView!
    @IBOutlet private weak var assetContentView: UIView!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: (AssetCellViewModelInputProtocol & AssetCellViewModelOutputProtocol)? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        assetTypeContainerView.layer.cornerRadius = 8.0
        assetContentView.layer.cornerRadius = 8.0
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        assetTypeContainerView.backgroundColor = viewModel.assetTypeBackgroundColor
        assetTypeImageView.image = viewModel.assetTypeImage
        assetTypeImageView.tintColor = viewModel.assetTypeTintColor
        
        contentLabel.text = viewModel.contentText
        
        assetContentView.backgroundColor = viewModel.assetContentBackgroundColor
        
        backgroundColor = viewModel.backgroundColor
    }
    
    // MARK: - Actions
    
}
