//
//  AssetPickerPresenter.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol AssetPickerPresenter {
    func back()
    func didSelect(image: UIImage?)
}

final class AssetPickerPresenterImpl {
    
    // MARK: - Private properties
    
    private let coordinator: AssetPickerCoordinator
    private weak var view: AssetPickerView?
    private var completion: (UIImage?) -> Void
    
    // MARK: - Init
    
    init(
        coordinator: AssetPickerCoordinator,
        view: AssetPickerView,
        completion: @escaping  (UIImage?) -> Void
    ) {
        self.coordinator = coordinator
        self.view = view
        self.completion = completion
    }
    
}

// MARK: - AssetPickerPresenter

extension AssetPickerPresenterImpl: AssetPickerPresenter {
    
    func back() {
        coordinator.back()
    }
    
    func didSelect(image: UIImage?) {
        completion(image)
        
        coordinator.back()
    }
    
}
