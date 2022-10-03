//
//  NewProjectViewController.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 01.10.2022.
//

import UIKit
import AVFoundation

protocol NewProjectView: AnyObject {
    func update(previewImage: UIImage?)
    func reloadRow(for indexPath: IndexPath)
}

final class NewProjectViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var previewView: UIView!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var assetsTableView: UITableView! {
        didSet {
            assetsTableView.register(ProjectAssetTableViewCell.nib, forCellReuseIdentifier: ProjectAssetTableViewCell.reuseIdentifier)
            assetsTableView.dataSource = self
            assetsTableView.delegate = self
        }
    }
    
    // MARK: - Public properties
    
    var presenter: NewProjectPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        initilizeComponents()
    }
    
    // MARK: - Private methods
    
    private func initilizeComponents() {
        guard let presenter = presenter else { return }
        
        view.backgroundColor = presenter.backgroundColor
    }

}

// MARK: - UITableViewDataSource

extension NewProjectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfItemsInSection ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = presenter?.cellViewModel(for: indexPath) else { return UITableViewCell() }
        
        switch viewModel {
        case let viewModel as ProjectAssetTableViewCellViewModelType:
            let cell = ProjectAssetTableViewCell.make(tableView, for: indexPath)
            cell.viewModel = viewModel
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension NewProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = presenter?.cellViewModel(for: indexPath) else { return UITableView.automaticDimension }
        
        return viewModel.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = presenter?.cellViewModel(for: indexPath) else { return }
        
        viewModel.didSelect()
    }
    
}

// MARK: - NewProjectView

extension NewProjectViewController: NewProjectView {
    
    func update(previewImage: UIImage?) {
        previewImageView.image = previewImage
    }
    
    func reloadRow(for indexPath: IndexPath) {
        assetsTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
