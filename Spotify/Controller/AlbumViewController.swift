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
    private var viewModels = [RecommendedTrackCellViewModel]()
    private var track = [AudioTrack]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
        // item
        let item = NSCollectionLayoutItem(
                            layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(60)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        //group
        let grup = NSCollectionLayoutGroup.vertical(
                            layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(80)),
                            subitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: grup)
        section.boundarySupplementaryItems = [
         NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        return section
    }))
    
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
        APICaller.shared.getAlbumDetails(for: album) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.track = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-",
                            artWorkURL: URL(string: $0.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Helpers
    private func setupView(){
        //share button
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        title = album.name
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActions))

    }
//
//    //MARK: - Actions
//    @objc private func didTapShare(){
//        guard let url = URL(string: album.artists.first?.external_urls["spotify"] ?? "") else {
//            return
//        }
//        print("debug: share url \(url)")
//        let controller = UIActivityViewController(
//            activityItems: [url],
//                         applicationActivities: [])
//        controller.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//        present(controller, animated: true)
//    }
    
    @objc func didTapActions(){

        let actionSheet = UIAlertController(title: album.name, message: "Actions", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else { return }
            APICaller.shared.addAlbumToLibrary(album: strongSelf.album) { success in
                
                DispatchQueue.main.async {
                    if success{
                        
                        let alert = UIAlertController(title: "Success", message: "Success saved album to library", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
                        strongSelf.present(alert, animated: true)
                        
                    }else{
                        let alert = UIAlertController(title: "Failed", message: "failed  to save album", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
                        strongSelf.present(alert, animated: true)
                    }
                }
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }

}

//MARK: - CollectionViewDelegate
extension AlbumViewController: UICollectionViewDelegate{
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    var track = track[indexPath.row]
    track.album = self.album
    PlaybackPresenter.shared.startPlayback(from: self, track: track)
}

func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView else {
        return UICollectionReusableView()
    }
    let headerViewModel = PlaylistHeaderViewModel(
        name: album.name,
        ownerName: album.artists.first?.name ?? "",
        description: "Release date: \(String.formatedDate(string: album.release_date))",
        playlistImage: URL(string: album.images.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
}

//MARK: - CollectionViewDataSource
extension AlbumViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
        return UICollectionViewCell()
    }
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }

}

//MARK: - PlaylitCollectionDelegate
extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        let trackWithAlbum: [AudioTrack] = track.compactMap {
            var track = $0
            track.album = self.album
            return track
        }

    
        PlaybackPresenter.shared.startPlayback(from: self, track: trackWithAlbum)
    }
}
