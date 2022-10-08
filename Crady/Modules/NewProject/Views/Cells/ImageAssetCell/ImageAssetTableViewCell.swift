//
//  ImageAssetTableViewCell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

class ImageAssetTableViewCell: UITableViewCell, CollectionCell {

    // MARK: - @IBOutlets
    
    @IBOutlet private weak var assetPreviewImageView: UIImageView!
    @IBOutlet private weak var assetTitleLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var removeButton: UIButton!
    
    // MARK: - Public properties
    
    var viewModel: ImageAssetTableViewCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
 
        assetPreviewImageView.image = viewModel.assetPreviewImage
        assetTitleLabel.text = viewModel.assetTitle
        
        editButton.setTitle("", for: .normal)
        removeButton.setTitle("", for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction private func didEdit(_ sender: Any) {
        viewModel?.didEdit()
    }
    
    @IBAction private func didRemove(_ sender: Any) {
        viewModel?.didRemove()
    }
    
}
