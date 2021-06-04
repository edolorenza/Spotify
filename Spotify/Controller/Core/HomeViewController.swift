//
//  ViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

enum BrowseSectionType{
    case newReleases(viewModels: [NewReleaseCellViewModel]) // 0
    case FeaturedPlaylist(viewModels: [FeaturedPlaylistCellViewModel]) //1
    case RecomendationsTracks(viewModels: [RecommendedTrackCellViewModel]) //2
    
    var title: String{
        switch self {
        case .newReleases:
            return "New Released Albums"
        case .FeaturedPlaylist:
            return "Featured Playlists"
        case .RecomendationsTracks:
            return "Recommended"
        }
    }
}

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private var newAlbums: [Album] = []
    private var playlist: [Playlist] = []
    private var track: [AudioTrack] = []
    
    private let spinner: UIActivityIndicatorView = {
        let spinner  = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var collectionView: UICollectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private var sections = [BrowseSectionType]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        setupView()
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    //MARK: - API
    private func fetchData() {
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: AllNewReleaseResponse?
        var featuredPlaylist: FeaturedPlaylistResponse?
        var recommendation: RecommendationsResponse?
        
        //New releases
        APICaller.shared.getAllNewRelease { result in
            defer {
                group.leave()
            }
            switch result {
                case.success(let model):
                    newReleases = model
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        //featured playlist
        APICaller.shared.getFeaturedPlaylist { result in
            defer {
                group.leave()
            }
            switch result {
                case.success(let model):
                    featuredPlaylist = model
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        //fetch genres
        APICaller.shared.getRecommendationGenres{ result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                //fetch recommendation genres
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendation = model
                    case . failure(let error):
                        print(error.localizedDescription)
                    }
                }
            
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        group.notify(queue: .main){
            guard let newAlbums = newReleases?.albums.items,
                  let playlist = featuredPlaylist?.playlists.items,
                  let track = recommendation?.tracks
            else { return }
            
            self.configureModels(newAlbums: newAlbums, track: track, playlist: playlist)
            
        }
        
       
    }
    //MARK: - Actions
    @objc func didTapSettings() {
        let controller = SettingsViewController()
        controller.title = "Settings"
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didTapLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              indexPath.section == 2
        else {
                return
        }
        
        let model = track[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to add this to playlist",
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async {
                let controller = LibraryPlaylistsViewController()
                controller.selectionHandler = {[weak self] playlist in
                    APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist) { success in
                        if success {
                            self?.addTrackAlert()
                        }else{
                            
                        }
                    }
                }
                controller.title = "Select Playlist"
                
                self?.present(UINavigationController(rootViewController: controller), animated: true)
            }
        }))
        present(actionSheet, animated: true)
    }
    

    
    //MARK: - Helpers
    private func setupView(){
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(NewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }

    
    private func configureModels(newAlbums: [Album], track: [AudioTrack], playlist: [Playlist]){
        //configure models
        self.newAlbums = newAlbums
        self.track = track
        self.playlist = playlist
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleaseCellViewModel(
                name: $0.name,
                artWorkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "_")
        })))
        
        sections.append(.FeaturedPlaylist(viewModels: playlist.compactMap({
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name)
        })))
                            
        sections.append(.RecomendationsTracks(viewModels: track.compactMap({
            return RecommendedTrackCellViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "-",
                artWorkURL: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
    }
    
    private func addLongTapGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    private func addTrackAlert(){
        let alert = UIAlertController(title: "Success", message: "Success add track to playlist", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
          NotificationCenter.default.post(name: .playlistSavedNotification, object: nil)
        }))
                                
        present(alert, animated: true)
    }
   
}
  

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        
        switch section {
        case .FeaturedPlaylist:
            let playlist = playlist[indexPath.row]
            let controller = PlaylistViewController(playlist: playlist)
            controller.title = playlist.name
            controller.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(controller, animated: true)
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let controller = AlbumViewController(album: album)
            controller.title = album.name
            controller.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(controller, animated: true)
        case .RecomendationsTracks:
            let track = track[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let model = sections[section].title
        header.configure(with: model)
        return header
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .FeaturedPlaylist(let viewModels):
            return viewModels.count
        case .RecomendationsTracks(let viewModels):
            return viewModels.count
        case .newReleases(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .FeaturedPlaylist(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistViewCell.identifier, for: indexPath) as? FeaturedPlaylistViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .RecomendationsTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
}

//MARK: - UICollectionViewCompositionalLayout
extension HomeViewController {
     static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        let supplementaryViews = [
         NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        
        switch section {
        case 0:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //vertical group in horizontal grup
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(390)),
                                subitem: item, count: 3)
            
            //group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                                  layoutSize: NSCollectionLayoutSize(
                                  widthDimension: .fractionalWidth(0.9),
                                  heightDimension: .absolute(390)),
                                  subitem: verticalGroup, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 1:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .absolute(170),
                                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //vertical group in horizontal grup
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .absolute(180),
                                heightDimension: .absolute(450)),
                                subitem: item, count: 2)
            //group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                                  layoutSize: NSCollectionLayoutSize(
                                  widthDimension: .absolute(180),
                                  heightDimension: .absolute(450)),
                                  subitem: verticalGroup, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
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
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //group
            let group = NSCollectionLayoutGroup.vertical(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(0.9),
                                heightDimension: .absolute(390)),
                                subitem: item, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
}

