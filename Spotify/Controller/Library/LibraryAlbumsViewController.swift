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
