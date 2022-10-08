//
//  Cell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol Cell {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

extension Cell {
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: .main)
    }
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
}

extension Cell where Self: UICollectionViewCell {
    
    static func make(_ collectionView: UICollectionView, for indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Self
    }
    
}

extension Cell where Self: UITableViewCell {
    
    static func make(_ tableView: UITableView, for indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Self
    }
    
}
