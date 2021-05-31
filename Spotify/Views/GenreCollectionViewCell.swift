//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Edo Lorenza on 31/05/21.
//

import UIKit
import SDWebImage

class GenreCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "GenreCollectionViewCell"
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.tintColor = .white
        iv.image = UIImage(systemName: "music.quarternote.3")
        return iv
    }()
    
    private let color: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemPink,
        .systemTeal,
        .darkGray,
        .systemGreen,
        .systemOrange,
        .systemYellow,
        .systemPurple,
        .systemIndigo
    ]

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
    
    //MARK: - Helpers
    private func setupView(){
        layer.cornerRadius = 6
        
        addSubview(genreLabel)
        genreLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(playlistImageView)
        playlistImageView.setDimensions(height: 65, width: 65)
        playlistImageView.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 6, paddingRight: 6)
    }
    
    func configure(with title: String) {
        genreLabel.text = title
        backgroundColor = color.randomElement()
    }
}
