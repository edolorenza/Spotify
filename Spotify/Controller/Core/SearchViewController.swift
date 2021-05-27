//
//  SearchViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
  
    //MARK: - Properties
    let searchController: UISearchController = {
        let result = SearchResultViewController()
        let vc = UISearchController(searchResultsController: result)
        vc.searchBar.placeholder = "Songs, Artist, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - API
    
    //MARK: - Helpers
    private func setupView(){
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
}

extension SearchViewController {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsController as? SearchResultViewController ,let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        //ferform search
        print(query)
    }
}
