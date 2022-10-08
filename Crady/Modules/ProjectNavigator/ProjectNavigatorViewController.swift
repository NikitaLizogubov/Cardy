//
//  ProjectNavigatorViewController.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit

protocol ProjectNavigatorView: AnyObject {
    
}

final class ProjectNavigatorViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var navigationView: NavigationView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var assetCollectionView: UICollectionView! {
        didSet {
            assetCollectionView.register(AssetEditCollectionViewCell.nib, forCellWithReuseIdentifier: AssetEditCollectionViewCell.reuseIdentifier)
            assetCollectionView.dataSource = self
            assetCollectionView.delegate = self
        }
    }
    @IBOutlet private weak var assetContainerView: UIView!
    
    // MARK: - Public properties
    
    var presenter: ProjectNavigatorPresenter?
    
    // MARK: - Private properties
    
    private var pageViewController: UIPageViewController!
    
    private var orderedViewControllers: [UIViewController] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        initilizeComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Override
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Public methods
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        orderedViewControllers = viewControllers
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        
        pageViewController.willMove(toParent: self)
        containerView.addFullSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        if let firstViewController = orderedViewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func initilizeComponents() {
        guard let presenter = presenter else { return }
        
        navigationView.viewModel = presenter.navigationViewModel

        [view, pageViewController.view].forEach({
            $0?.backgroundColor = presenter.backgroundColor
        })
        
        assetContainerView.backgroundColor = presenter.assetContainerBackgroundColor
    }

}

// MARK: - UICollectionViewDataSource

extension ProjectNavigatorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfItemsInSection ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = presenter?.cellViewModels[indexPath.row] else { return UICollectionViewCell() }
        
        switch viewModel {
        case let viewModel as AssetEditCollectionCellViewModelType:
            let cell = AssetEditCollectionViewCell.make(collectionView, for: indexPath)
            cell.viewModel = viewModel
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}


// MARK: - UICollectionViewDelegate

extension ProjectNavigatorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = presenter?.cellViewModels[indexPath.row] else { return }
        
        viewModel.didSelect()
    }
    
}

// MARK: UIPageViewControllerDataSource

extension ProjectNavigatorViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}

// MARK: - ProjectNavigatorView

extension ProjectNavigatorViewController: ProjectNavigatorView {
    
}
