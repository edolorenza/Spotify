//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 02/06/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    //MARK: - Properties
    var albums = [SavedAlbum]()
    private let noAlbums = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.clipsToBounds = true
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        noAlbums.delegate = self
        fetchData()
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.fetchData()
        })
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        tableView.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(noAlbums)
        noAlbums.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noAlbums.center = view.center
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    //MARK: - API
    func fetchData(){
        APICaller.shared.getCurrentUserAlbums {[weak self] result in
            self?.albums.removeAll()
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
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
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: self.tableView)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        
        let albumTodelete = albums[indexPath.row]
        let actionSheet = UIAlertController(
            title: albumTodelete.album.name,
            message: "Would you like to remove this from playlist",
            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        actionSheet.addAction(UIAlertAction(
        title: "Remove",
        style: .destructive,
        handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            APICaller.shared.removeAlbumFromPlaylist(album: albumTodelete) { success in
                DispatchQueue.main.async {
                    if success {
                        strongSelf.albums.remove(at: indexPath.row)
                        strongSelf.tableView.reloadData()
                        
                        let alert = UIAlertController(title: "Success", message: "Success remove track to playlist", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
                        strongSelf.present(alert, animated: true)
                    }else {
                        print("failed to delte")
                    }
                }
            }
        }))

    present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: - Helpers
    private func setupView(){
        noAlbums.configure(with: ActionLabelViewViewModel(
                                text: "You Dont have any albums yet",
                                actionTitle: "Create"))
        
        view.backgroundColor = .systemBackground
    }
    
    private func updateUI(){
        if albums.isEmpty {
            noAlbums.isHidden = false
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
    
    
}

//MARK: - ActionLabelViewDelegate
extension LibraryAlbumsViewController: ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

//MARK: - UITableViewDelegate
extension LibraryAlbumsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedAlbums = albums[indexPath.row]
       
        
        let controller = AlbumViewController(album: savedAlbums.album)
        controller.title = savedAlbums.album.name
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

//MARK: - UITableViewDataSource
extension LibraryAlbumsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let savedAlbums = albums[indexPath.row].album
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                        title: savedAlbums.name,
                        subtitle: savedAlbums.artists.first?.name ?? "",
                        imageURL: URL(string: savedAlbums.images.first?.url ?? "")))
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
