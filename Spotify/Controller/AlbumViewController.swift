//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 26/05/21.
//

import UIKit

class AlbumViewController: UIViewController {
    //MARK: - Properties
    let album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    
    //MARK: - API
    private func fetchData(){
        APICaller.shared.getAlbumDetails(for: album) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model): break
                case .failure(let eroor): break
                }
            }
        }
    }
    
    //MARK: - Helpers
    private func setupView(){
        title = album.name
        view.backgroundColor = .systemBackground
    }
    

}
