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
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.clipsToBounds = true
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        return tableView
    }()
    
    
    public var selectionHandler: ((Playlist) -> Void)?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        noPlaylist.delegate = self
        fetchData()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(noPlaylist)
        noPlaylist.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylist.center = view.center
        view.addSubview(tableView)
        tableView.frame = view.bounds
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
    
    //MARK: - Actions
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
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
            tableView.reloadData()
            tableView.isHidden = false
            
        }
    }
    
    private func setupTableView(){

        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func showCreatePlaylistsAlert(){
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
                    self.fetchData()
                }
                else {
                    print("failed to create playlist")
                }
            }
        }))
        present(alert, animated: true)
    }
}

//MARK: - ActionLabelViewDelegate
extension LibraryPlaylistsViewController: ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
       showCreatePlaylistsAlert()
    }
}

//MARK: - UITableViewDelegate
extension LibraryPlaylistsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        guard  selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let controller = PlaylistViewController(playlist: playlist)
        controller.title = playlist.name
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension LibraryPlaylistsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                        title: playlist.name,
                        subtitle: playlist.owner.display_name,
                        imageURL: URL(string:playlist.images.first?.url ?? "")))
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
