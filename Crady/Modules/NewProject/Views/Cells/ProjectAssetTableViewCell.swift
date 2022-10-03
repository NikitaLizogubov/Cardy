//
//  ProjectAssetTableViewCell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

class ProjectAssetTableViewCell: UITableViewCell, CollectionCell {

    // MARK: - @IBOutlets
    
    @IBOutlet private weak var assetPreviewImageView: UIImageView!
    @IBOutlet private weak var assetTitleLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: ProjectAssetTableViewCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
 
        assetPreviewImageView.image = viewModel.assetPreviewImage
        assetTitleLabel.text = viewModel.assetTitle
    }
    
    @IBAction private func didEdit(_ sender: Any) {
        viewModel?.didEdit()
    }
    
}
