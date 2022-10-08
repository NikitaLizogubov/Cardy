//
//  NavigationView.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class NavigationView: XibView {
    
    // MARK: - Public properties
    
    var viewModel: NavigationViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
    }
    
    // MARK: - Actions
    
    @IBAction private func didBack(_ sender: Any) {
        viewModel?.back()
    }
    
    
}
