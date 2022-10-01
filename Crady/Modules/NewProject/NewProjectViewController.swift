//
//  NewProjectViewController.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol NewProjectView: AnyObject {
    
}

final class NewProjectViewController: UIViewController {

    // MARK: - Public properties
    
    var presenter: NewProjectPresenter?
    
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

// MARK: - NewProjectView

extension NewProjectViewController: NewProjectView {
    
}
