//
//  AssetPicker.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit

protocol AssetPickerView: AnyObject {
    
}

final class AssetPicker: NSObject {
    
    // MARK: - Public properties
    
    var presenter: AssetPickerPresenter?

    let pickerController: UIImagePickerController
    
    // MARK: - Init

    init(sourceType: UIImagePickerController.SourceType) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.sourceType = sourceType
        self.pickerController.mediaTypes = ["public.image"]
    }

}

// MARK: - UIImagePickerControllerDelegate

extension AssetPicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter?.back()
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            presenter?.back()
            return
        }
        
        presenter?.didSelect(image: image)
    }
}

// MARK: - UINavigationControllerDelegate

extension AssetPicker: UINavigationControllerDelegate {

}

// MARK: - UINavigationControllerDelegate

extension AssetPicker: AssetPickerView {

}
