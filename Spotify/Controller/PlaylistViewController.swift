//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

class PlaylistViewController: UIViewController {

    //MARK: - Properties
    let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
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
    
    private func fetchData(){
        APICaller.shared.getPlaylistDetails(for: playlist) { result in
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
        title = playlist.name
        view.backgroundColor = .systemBackground
    }
    

}
