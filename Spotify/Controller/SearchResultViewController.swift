//
//  SearchResultViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

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
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func update(with results: [SearchResult]){
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
        
        let track = results.filter {
            switch $0 {
            case .track:
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
            SearchSection(title: "Artist", results: artists),
            SearchSection(title: "Album", results: albums),
            SearchSection(title: "Track", results: track),
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
            break
        case .album(let model):
            let controller = AlbumViewController(album: model)
            controller.navigationItem.largeTitleDisplayMode = .never
            let navController = UINavigationController(rootViewController: controller)
            delegate?.showResult(controller: controller)
        case .playlist(let model):
            let controller = PlaylistViewController(playlist: model)
            controller.navigationItem.largeTitleDisplayMode = .never
            delegate?.showResult(controller: controller)
        case .track(let model):
            break
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .album(let model):
            cell.textLabel?.text = model.name
        case.playlist(let model):
            cell.textLabel?.text = model.name
        case .track(let model):
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sections[section].title
        return sectionTitle
    }
}
