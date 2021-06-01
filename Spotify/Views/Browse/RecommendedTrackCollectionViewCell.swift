//
//  RecommendaedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Edo Lorenza on 25/05/21.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "RecommendedTrackCollectionViewCell"

    private let albumCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()

    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
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
        albumCoverImageView.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    //MARK: - Helpers
    private func setupView() {
        trackNameLabel.sizeToFit()
        
        let imageWidth: CGFloat = contentView.frame.height
        contentView.addSubview(albumCoverImageView)
        albumCoverImageView.anchor(top: topAnchor, left: leftAnchor)
        albumCoverImageView.setDimensions(height: imageWidth, width: imageWidth)
        
        let stack = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel])
        contentView.addSubview(stack)
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 4
        stack.centerY(inView: albumCoverImageView)
        stack.anchor(left: albumCoverImageView.rightAnchor, paddingLeft: 5)
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel){
        albumCoverImageView.sd_setImage(with: viewModel.artWorkURL)
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
    
}

