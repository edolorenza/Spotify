//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by Edo Lorenza on 25/05/21.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTrackLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
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
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTrackLabel.sizeToFit()
        
        let imagasize: CGFloat = contentView.frame.height-10
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        albumCoverImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 5)
        albumCoverImageView.setDimensions(height: imagasize, width: imagasize)
        
        addSubview(albumNameLabel)
        albumNameLabel.anchor(top: topAnchor, left: albumCoverImageView.rightAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5)
        
        addSubview(artistNameLabel)
        artistNameLabel.anchor(top: albumNameLabel.bottomAnchor, left: albumCoverImageView.rightAnchor, paddingTop: 5, paddingLeft: 5)
        
        addSubview(numberOfTrackLabel)
        numberOfTrackLabel.anchor(left: albumCoverImageView.rightAnchor, bottom: bottomAnchor, paddingLeft: 5, paddingBottom: 5)
        
    }
    
    func configure(with viewModel: NewReleaseCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTrackLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artWorkURL)
    }
}
