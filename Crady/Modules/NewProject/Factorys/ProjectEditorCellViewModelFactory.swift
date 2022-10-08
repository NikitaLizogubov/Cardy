//
//  ProjectEditorCellViewModelFactory.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 04.10.2022.
//

import UIKit

protocol ProjectEditorCellViewModelDelegate: AnyObject {
    func didEdit(fragment: ImageFragment, for index: Int)
    func didEdit(fragment: TextFragment, for index: Int)
}

protocol ProjectEditorCellViewModelFactory {
    func make(fragment: Fragment, for index: Int, with delegate: ProjectEditorCellViewModelDelegate) -> CellViewModel?
}

struct ProjectEditorCellViewModelFactoryImpl { }

// MARK: - CanvasEngineFragmentFactory

extension ProjectEditorCellViewModelFactoryImpl: ProjectEditorCellViewModelFactory {
    
    func make(fragment: Fragment, for index: Int, with delegate: ProjectEditorCellViewModelDelegate) -> CellViewModel? {
        switch fragment {
        case let fragment as ImageFragment:
            let viewModel = ImageAssetTableViewCellViewModel(fragment: fragment) {
                delegate.didEdit(fragment: fragment, for: index)
            }
            return viewModel
        case let fragment as TextFragment:
            let viewModel = TextAssetTableViewCellViewModel(fragment: fragment) {
                delegate.didEdit(fragment: fragment, for: index)
            }
            return viewModel
        default:
            return nil
        }
    }
    
}
