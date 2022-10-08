//
//  TemplateCollectionViewCell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

final class TemplateCollectionViewCell: UICollectionViewCell, Cell {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: TemplateCollectionViewCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
 
        titleLabel.text = viewModel.title
        
        backgroundColor = viewModel.backgroundColor
    }
    
}
