//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    private let controlsView = PlayerControlsView()
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemBlue
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDataSource()
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
    private func configureDataSource(){
        imageView.sd_setImage(with: dataSource?.imageURL)
        controlsView.configure(with:  PlayerControlsViewViewModel(
                                title: dataSource?.songTitle,
                                subtitle: dataSource?.subtitle))
    }
    
}

//MARK: - PlayerControlsViewDelegate
extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPause(_ playerControlView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
     
    func playerControlsViewDidTapForwardButton(_ playerControlView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    
}
