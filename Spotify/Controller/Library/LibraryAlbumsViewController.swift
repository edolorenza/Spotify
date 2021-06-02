//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 02/06/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    //MARK: - Properties
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Helpers
    private func setupView(){
        view.backgroundColor = .systemOrange
    }
}

