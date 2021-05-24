//
//  ViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
    }
    //MARK: - Actions
    @objc func didTapSettings() {
        let controller = ProfileViewController()
        controller.title = "Profile"
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }

}

