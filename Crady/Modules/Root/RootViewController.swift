//
//  RootViewController.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol RootView: AnyObject {
    
}

final class RootViewControllerImpl: UIViewController {
    
    // MARK: -
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
        }
    }
    
    // MARK: - Public properties
    
    var presenter: RootPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeComponents()
    }
    
    // MARK: - Private methods
    
    private func initilizeComponents() {
        guard let presenter = presenter else { return }

        view.backgroundColor = presenter.backgroundColor
    }

}

// MARK: - UICollectionViewDataSource

extension RootViewControllerImpl: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
}

// MARK: - RootView

extension RootViewControllerImpl: RootView {
    
}
