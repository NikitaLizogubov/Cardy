//
//  ProjectNavigatorViewController.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit

protocol ProjectNavigatorView: AnyObject {
    
}

final class ProjectNavigatorViewController: UIPageViewController {
    
    // MARK: - Public properties
    
    var presenter: ProjectNavigatorPresenter?
    
    // MARK: - Private properties
    
    private var orderedViewControllers: [UIViewController] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
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
    
    // MARK: - Public methods
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        orderedViewControllers = viewControllers
        
        if let firstViewController = viewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func initilizeComponents() {
        guard let presenter = presenter else { return }
        
        navigationItem.title = presenter.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: presenter.previewButtonTitle,
            style: .plain,
            target: self,
            action: #selector(didPreview)
        )

        view.backgroundColor = presenter.backgroundColor
    }
    
    // MARK: - Actions
    
    @objc private func didPreview(_ sender: Any) {
        presenter?.didPreview()
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
