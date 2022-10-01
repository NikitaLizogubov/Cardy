//
//  CollectionCellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol CollectionCellViewModel {
    var height: CGFloat { get }
    
    func didSelect()
}

extension CollectionCellViewModel {
    
    var height: CGFloat {
        UITableView.automaticDimension
    }
    
    func didSelect() { }
    
}
