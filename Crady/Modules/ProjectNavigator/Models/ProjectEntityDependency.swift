//
//  ProjectEntityDependency.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 04.10.2022.
//

import Foundation

struct ProjectEntityDependency {
    let fragments: [Fragment]
    let canvasEngine: CanvasEngine
    let cellViewModelFactory: ProjectEditorCellViewModelFactory
}
