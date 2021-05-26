//
//  FeaturedPlaylist.swift
//  Spotify
//
//  Created by Edo Lorenza on 25/05/21.
//

import UIKit
import SDWebImage

class FeaturedPlaylistViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "FeaturedPlaylistViewCell"
    
    private let artworkCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecyc;e
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Helpers
    private func setupView() {
     
        let imageWidth: CGFloat = contentView.frame.width
//        contentView.backgroundColor = .secondarySystemBackground
        addSubview(artworkCoverImageView)
        artworkCoverImageView.anchor(top: topAnchor)
        artworkCoverImageView.setDimensions(height: 160, width: imageWidth)
    

        addSubview(playlistNameLabel)
        playlistNameLabel.anchor(top: artworkCoverImageView.bottomAnchor, left: leftAnchor, paddingTop: 4)

        addSubview(creatorNameLabel)
        creatorNameLabel.anchor(top: playlistNameLabel.bottomAnchor, left: leftAnchor,  paddingTop: 4)
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel){
        artworkCoverImageView.sd_setImage(with: viewModel.artworkURL)
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
    }
    
}
