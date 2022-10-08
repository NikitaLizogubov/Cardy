//
//  CellViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol CellViewModel {
    var height: CGFloat { get }
    
    func didSelect()
}

extension CellViewModel {
    
    var height: CGFloat {
        UITableView.automaticDimension
    }
    
    func didSelect() { }
    
}
