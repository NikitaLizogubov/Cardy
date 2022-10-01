//
//  CollectionCell.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol CollectionCell {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

extension CollectionCell {
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: .main)
    }
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
}

extension CollectionCell where Self: UICollectionViewCell {
    
    static func make(_ collectionView: UICollectionView, for indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Self
    }
    
}

extension CollectionCell where Self: UITableViewCell {
    
    // TODO: Add the same for tableView
    
}
