//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

class LibraryViewController: UIViewController {
    //MARK: - Properties
    
    enum State {
        case playlists
        case albums
    }
    var state: State = .playlists
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    //MARK: - Actions
    @objc func didTapPlaylist(){
        state = .playlists
        UIView.animate(withDuration: 0.2){
            self.layoutIndicator()
        }
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc func didTapAlbums(){
        state = .albums
        UIView.animate(withDuration: 0.2){
            self.layoutIndicator()
        }
        scrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
    }
    
    //MARK: - Helpers
    private func setupView(){
        view.backgroundColor = .systemBackground
        view.addSubview(playlistsButton)
        view.addSubview(albumsButton)
        playlistsButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)

        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 60)
        scrollView.contentSize = CGSize(width: view.frame.width*2, height: scrollView.frame.height)

        addChildren()
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playlistsButton.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 100, height: 50)
        albumsButton.frame = CGRect(x: 100, y: view.safeAreaInsets.top, width: 100, height: 50)
        layoutIndicator()
    }
    
    private func addChildren() {
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        albumsVC.didMove(toParent: self)
    }
    
    func layoutIndicator() {
        switch state {
        case .playlists:
            view.addSubview(indicatorView)
            indicatorView.frame = CGRect(
                x: 0,
                y: playlistsButton.frame.origin.y+50,
                width: 100,
                height: 3
            )
            
        case .albums:
            view.addSubview(indicatorView)
            indicatorView.frame = CGRect(
                x: 100,
                y: albumsButton.frame.origin.y+50,
                width: 100,
                height: 3
            )
        }
    }
    
    private func update(for state: State){
        self.state = state
        UIView.animate(withDuration: 0.2){
            self.layoutIndicator()
        }
    }

}

//MARK: - UIScrollViewDelegate
extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.frame.width-80){
            update(for: .albums)
        }else{
            update(for: .playlists)
        }
    }
    
}
