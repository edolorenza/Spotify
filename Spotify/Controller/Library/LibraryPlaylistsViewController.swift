//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 02/06/21.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    //MARK: - Properties
    var playlists = [Playlist]()
    private let noPlaylist = ActionLabelView()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        noPlaylist.delegate = self
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(noPlaylist)
        noPlaylist.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylist.center = view.center
    }
    
    //MARK: - API
    func fetchData(){
        APICaller.shared.getCurrentUserPlaylists {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Helpers
    private func setupView(){
        noPlaylist.configure(with: ActionLabelViewViewModel(
                                text: "You Dont have any playlists yet",
                                actionTitle: "Create"))
        
        view.backgroundColor = .systemBackground
    }
    
    private func updateUI(){
        if playlists.isEmpty {
            noPlaylist.isHidden = false
        }else {
            noPlaylist.isHidden = false
        }
    }
    
}

//MARK: - ActionLabelViewDelegate
extension LibraryPlaylistsViewController: ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        let alert = UIAlertController(title: "New Playlists", message: "Enter Playlists Name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlists..."
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
            !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            APICaller.shared.createPlaylis(name: text) { success in
                if success{
                    // refresh list of playlist
                }
                else {
                    print("failed to create playlist")
                }
            }
        }))
        present(alert, animated: true)
    }
}
