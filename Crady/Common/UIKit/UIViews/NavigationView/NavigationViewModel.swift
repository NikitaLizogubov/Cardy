//
//  NavigationViewViewModel.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import Foundation

protocol NavigationViewModelInputProtocol {
    
}

protocol NavigationViewModelOutputProtocol {
    func back()
}

typealias NavigationViewModelType =
    NavigationViewModelInputProtocol &
    NavigationViewModelOutputProtocol

final class NavigationViewModel {
    
    // MARK: - Private properties
    
    private let backHandler: (() -> Void)?
    
    // MARK: - Init
    
    init(backHandler: (() -> Void)? = nil) {
        self.backHandler = backHandler
    }
    
}

// MARK: - NavigationViewModelInputProtocol

extension NavigationViewModel: NavigationViewModelInputProtocol {
    
    
    
}

// MARK: - NavigationViewViewModelOutputProtocol

extension NavigationViewModel: NavigationViewModelOutputProtocol {
    
    func back() {
        backHandler?()
    }
    
}
