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
    }
    
    // MARK: - Public methods
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        orderedViewControllers = viewControllers
        
        if let firstViewController = viewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
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
