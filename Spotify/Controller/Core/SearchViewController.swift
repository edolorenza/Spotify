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
        vc.searchBar.placeholder = "Songs, Artists, Albums, Playlists"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
        // item
        let item = NSCollectionLayoutItem(
                            layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
        
        //group
        let group = NSCollectionLayoutGroup.horizontal(
                            layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(150)),
                            subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        //section header playlist
        let section = NSCollectionLayoutSection(group: group)
        return section
    }))
    
    
    private var categories = [Category]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    
    //MARK: - API
    private func fetchData(){
        APICaller.shared.getAllCategories {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    //MARK: - Helpers
    private func setupView(){
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
    }
    
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultController = searchController.searchResultsController as? SearchResultViewController,
            let query = searchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultController.delegate = self
        
        APICaller.shared.search(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}

//MARK: - SearchResultViewControllerDelegate
extension SearchViewController: SearchResultViewControllerDelegate{
    func showResult(controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Search Bar update Result
extension SearchViewController {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsController as? SearchResultViewController ,let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
    }
}

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let controller = CategoryViewController(category: category)
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else  {
            return CategoryCollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(
                        title: category.name,
                        artWorkURL: URL(string:category.icons.first?.url ?? "")))
        return cell
    }
}
