//
//  RootViewController.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol RootView: AnyObject {
    
}

final class RootViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(TemplateCollectionViewCell.nib, forCellWithReuseIdentifier: TemplateCollectionViewCell.reuseIdentifier)
            collectionView.dataSource = self
            collectionView.delegate = self
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
        
        navigationItem.title = presenter.navigationTitle

        view.backgroundColor = presenter.backgroundColor
    }

}

// MARK: - UICollectionViewDataSource

extension RootViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfItemsInSection ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = presenter?.cellViewModel(for: indexPath) else { return UICollectionViewCell() }
        
        switch viewModel {
        case let viewModel as TemplateCollectionViewCellViewModelType:
            let cell = TemplateCollectionViewCell.make(collectionView, for: indexPath)
            cell.viewModel = viewModel
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension RootViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = presenter?.cellViewModel(for: indexPath) else { return }
        
        viewModel.didSelect()
    }
    
}

// MARK: - RootView

extension RootViewController: RootView {
    
}
