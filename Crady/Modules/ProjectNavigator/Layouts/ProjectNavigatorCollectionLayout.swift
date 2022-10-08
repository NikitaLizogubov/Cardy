//
//  ProjectNavigatorCollectionLayout.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

final class ProjectNavigatorCollectionLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        itemSize = CGSize(width: 60.0, height: collectionView.frame.height)
        sectionInset = UIEdgeInsets(top: .zero, left: 16.0, bottom: .zero, right: .zero)
        scrollDirection = .horizontal
        minimumLineSpacing = 16.0
    }
    
}
