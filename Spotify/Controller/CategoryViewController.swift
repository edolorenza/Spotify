//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 31/05/21.
//

import UIKit

class CategoryViewController: UIViewController {
    //MARK: - Properties
    let category: Category
    
    private let collectionView = UICollectionView (frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                          widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(225)),
                subitem: item,
                count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return NSCollectionLayoutSection(group: group)
        
    }))
    
    init(category: Category){
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var playlists = [Playlist]()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    //MARK: - API
    private func fetchData(){
        APICaller.shared.getCategoryPlaylist(categori: category) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlist):
                    self?.playlists = playlist
                    self?.collectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Helpers
    private func setupView(){
        title = category.name
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        collectionView.register(FeaturedPlaylistViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistViewCell.identifier)
    }
}


//MARK: - UICollectionViewDelegate
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        let controller = PlaylistViewController(playlist: playlist)
        controller.title = playlist.name
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistViewCell.identifier, for: indexPath) as? FeaturedPlaylistViewCell else {
            return FeaturedPlaylistViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: FeaturedPlaylistCellViewModel(
                        name: playlist.name,
                        artworkURL: URL(string:playlist.images.first?.url ?? ""),
                        creatorName: playlist.name))
        return cell
    }
}
