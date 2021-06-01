//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

class PlayerViewController: UIViewController {
    private let controlsView = PlayerControlsView()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemBlue
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Actions
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction(){
        
    }

   //MARK: - Helpers
    private func setupView(){
        configureBarButton()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        let imageSize = view.frame.width - 40
        imageView.centerX(inView: view.self, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        imageView.setDimensions(height: imageSize, width: imageSize)
        
        view.addSubview(controlsView)
        controlsView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 2, paddingBottom: 2, paddingRight: 2)
        
        controlsView.delegate = self
    }

    private func configureBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
}

//MARK: - PlayerControlsViewDelegate
extension PlayerViewController: PlayerControlsViewDelegate {
    func PlayerControlsViewDidTapPlayPause(_ playerControlView: PlayerControlsView) {
        print("PAUSE")
    }
    
    func PlayerControlsViewDidTapBackwardButton(_ playerControlView: PlayerControlsView) {
        print("BACKWARD")
    }
    
    func PlayerControlsViewDidTapForwardButton(_ playerControlView: PlayerControlsView) {
        print("NEXT")
    }
    
    
}
