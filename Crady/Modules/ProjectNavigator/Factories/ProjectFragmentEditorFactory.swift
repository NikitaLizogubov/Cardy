//
//  ProjectFragmentEditorFactory.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03.10.2022.
//

import UIKit

protocol ProjectFragmentEditorFactory {
    func makeCoordinator(project: Project, content: Content, parentViewController: UIViewController?) -> Coordinator?
}

struct ProjectFragmentEditorFactoryImp {
    
}

// MARK: - ProjectFragmentEditorFactory

extension ProjectFragmentEditorFactoryImp: ProjectFragmentEditorFactory {
    
    func makeCoordinator(project: Project, content: Content, parentViewController: UIViewController?) -> Coordinator? {
        switch content {
        case let content as ImageContent:
            return NewProjectCoordinatorImpl(project: project, content: content, parentViewController: parentViewController)
        default:
            return nil
        }
    }
    
}
