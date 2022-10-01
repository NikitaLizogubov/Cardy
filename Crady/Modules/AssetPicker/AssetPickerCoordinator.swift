//
//  AssetPickerCoordinator.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol AssetPickerCoordinator: AnyObject {
    func back()
}

final class AssetPickerCoordinatorImpl: Coordinator {
    
    // MARK: - Private properties
    
    // Injection
    private let sourceType: UIImagePickerController.SourceType
    private var completion: (UIImage?) -> Void
    
    // Local
    private var assetPicker: AssetPicker?
    
    // MARK: - Init
    
    init(
        sourceType: UIImagePickerController.SourceType,
        completion: @escaping (UIImage?) -> Void,
        parentViewController: UIViewController?
    ) {
        self.sourceType = sourceType
        self.completion = completion
        
        super.init(parentViewController: parentViewController)
    }
    
    // MARK: - Override
    
    override func start() {
        let assetPicker = AssetPicker(sourceType: sourceType)
        let presenter = AssetPickerPresenterImpl(coordinator: self, view: assetPicker, completion: completion)
        assetPicker.presenter = presenter
        
        self.assetPicker = assetPicker
        self.viewController = assetPicker.pickerController
        
        parentViewController?.present(assetPicker.pickerController, animated: true)
    }
    
}

// MARK: - AssetPickerCoordinator

extension AssetPickerCoordinatorImpl: AssetPickerCoordinator {
    
    func back() {
        viewController?.dismiss(animated: true) {
            self.assetPicker = nil
        }
    }
    
}
