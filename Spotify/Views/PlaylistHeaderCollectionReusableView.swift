//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Edo Lorenza on 26/05/21.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}
final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
     //MARK: - Properties
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "photo")
        return iv
    }()
    
    private lazy var playAllButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 21
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Actions
    @objc private func didTapPlayAll() {
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    //MARK: - Helpers
    private func setupView() {
        let imageSize = frame.width/1.5
        addSubview(playlistImageView)
        playlistImageView.centerX(inView: self)
        playlistImageView.anchor(top:topAnchor, paddingTop: 8)
        playlistImageView.setDimensions(height: imageSize, width: imageSize)

        let stack = UIStackView(arrangedSubviews: [nameLabel, ownerLabel])
        addSubview(stack)
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 2
        stack.anchor(top: playlistImageView.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 4)

        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 20)
        
        addSubview(playAllButton)
        playAllButton.setDimensions(height: 42, width: 42)
        playAllButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 4, paddingRight: 8)
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel){
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        playlistImageView.sd_setImage(with: viewModel.playlistImage)
    }
}

