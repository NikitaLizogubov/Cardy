//
//  ProjectEditorCellViewModelFactory.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 04.10.2022.
//

import UIKit

protocol ProjectEditorCellViewModelDelegate: AnyObject {
    func didUpload(fragment: ImageFragment, for index: Int)
    func didEdit(fragment: ImageFragment)
    func didRemove(fragment: ImageFragment, for index: Int)
}

protocol ProjectEditorCellViewModelFactory {
    func make(fragment: Fragment, for index: Int, with delegate: ProjectEditorCellViewModelDelegate) -> CollectionCellViewModel?
}

struct ProjectEditorCellViewModelFactoryImpl { }

// MARK: - CanvasEngineFragmentFactory

extension ProjectEditorCellViewModelFactoryImpl: ProjectEditorCellViewModelFactory {
    
    func make(fragment: Fragment, for index: Int, with delegate: ProjectEditorCellViewModelDelegate) -> CollectionCellViewModel? {
        switch fragment {
        case let fragment as ImageFragment:
            let viewModel = ImageAssetTableViewCellViewModel(asset: fragment.image, uploadHandler: {
                delegate.didUpload(fragment: fragment, for: index)
            }, editHandler: {
                delegate.didEdit(fragment: fragment)
            }, removeHandler: {
                delegate.didRemove(fragment: fragment, for: index)
            })
            return viewModel
        default:
            return nil
        }
    }
    
}
