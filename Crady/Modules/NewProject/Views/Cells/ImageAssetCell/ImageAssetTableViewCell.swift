//
//  ImageAssetTableViewCell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class ImageAssetTableViewCell: UITableViewCell, Cell {
    
    // MARK: - IBOutlets
    // MARK: - Public properties
    
    var viewModel: (ImageAssetCellViewModelInputProtocol & ImageAssetCellViewModelOutputProtocol)? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private properties
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    
    private func setupUI() {
        
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
    }
    
    // MARK: - Actions
    
}
