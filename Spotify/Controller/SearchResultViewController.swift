//
//  SearchResultViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit
import SafariServices

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultViewControllerDelegate: AnyObject {
    func showResult(controller: UIViewController)
}

class SearchResultViewController: UIViewController {
    //MARK: - Properties
    private var sections = [SearchSection]()
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableview.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.isHidden = true
        return tableview
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    //MARK: - Helpers
    private func setupView(){
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func update(with results: [SearchResult]){
        
        let track = results.filter {
            switch $0 {
            case .track:
                return true
            default: return false
            }
        }
        
        let artists = results.filter {
            switch $0 {
            case .artist:
                return true
            default: return false
            }
        }
        
        let albums = results.filter {
            switch $0 {
            case .album:
                return true
            default: return false
            }
        }
    
        let playlist = results.filter {
            switch $0 {
            case .playlist:
                return true
            default: return false
            }
        }
        
        self.sections = [
            SearchSection(title: "Song", results: track),
            SearchSection(title: "Artist", results: artists),
            SearchSection(title: "Album", results: albums),
            SearchSection(title: "Playlist", results: playlist)
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
}

//MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(let model):
            print(model)
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true, completion: nil)
            
        case .album(let model):
            let controller = AlbumViewController(album: model)
            controller.navigationItem.largeTitleDisplayMode = .never
            delegate?.showResult(controller: controller)
        case .playlist(let model):
            let controller = PlaylistViewController(playlist: model)
            controller.navigationItem.largeTitleDisplayMode = .never
            delegate?.showResult(controller: controller)
        case .track(let model):
            PlaybackPresenter.shared.startPlayback(from: self, track: model)
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        
        case .track(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: model.name,
                subtitle: model.artists.first?.name ?? "-",
                imageURL: URL(string: model.album?.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
    
        case .artist(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: model.name,
                imageURL: URL(string: model.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
        case .album(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: model.name,
                subtitle: model.artists.first?.name ?? "-",
                imageURL: URL(string: model.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
        case.playlist(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: model.name,
                subtitle: model.owner.display_name,
                imageURL: URL(string: model.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sections[section].title
        return sectionTitle
    }
}
