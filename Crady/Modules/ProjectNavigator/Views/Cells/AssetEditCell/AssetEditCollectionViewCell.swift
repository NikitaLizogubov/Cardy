//
//  AssetEditCollectionViewCell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class AssetEditCollectionViewCell: UICollectionViewCell, Cell {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var assetImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: AssetEditCollectionCellViewModelType? {
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
        containerView.layer.cornerRadius = 8.0
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
 
        assetImageView.image = viewModel.image
        assetImageView.tintColor = viewModel.tintColor
        
        titleLabel.text = viewModel.title
        
        containerView.backgroundColor = viewModel.backgroundColor
    }

}
