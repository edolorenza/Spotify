//
//  ViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

enum BrowseSectionType{
    case newReleases(viewModels: [NewReleaseCellViewModel]) // 0
    case FeaturedPlaylist(viewModels: [NewReleaseCellViewModel]) //1
    case RecomendationsTracks(viewModels: [NewReleaseCellViewModel]) //2
}

class HomeViewController: UIViewController {
    
    //MARK: - Properties
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func configureModels(newAlbums: [Album], track: [AudioTrack], playlist: [Playlist]){
        //configure models
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleaseCellViewModel(name: $0.name, artWorkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "_")
        })))
        sections.append(.FeaturedPlaylist(viewModels: []))
        sections.append(.RecomendationsTracks(viewModels: []))
        collectionView.reloadData()
    }
}
  

extension HomeViewController: UICollectionViewDelegate {
    
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
            cell.backgroundColor = .red
            return cell
        case .RecomendationsTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
}

extension HomeViewController {
     static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
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
            return section
        case 1:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .absolute(200),
                                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //vertical group in horizontal grup
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .absolute(200),
                                heightDimension: .absolute(400)),
                                subitem: item, count: 2)
            //group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                                  layoutSize: NSCollectionLayoutSize(
                                  widthDimension: .absolute(200),
                                  heightDimension: .absolute(400)),
                                  subitem: verticalGroup, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case 2:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(80)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //vertical group in horizontal grup
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalWidth(1.0)),
                                subitem: item, count: 1)
        
            //group
            let grup = NSCollectionLayoutGroup.vertical(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(100)),
                                subitem: verticalGroup, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: grup)
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

