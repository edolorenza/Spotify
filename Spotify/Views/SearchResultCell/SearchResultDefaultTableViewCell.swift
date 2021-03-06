//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Edo Lorenza on 01/06/21.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    //MARK: - Helpers
    private func setupView() {
        self.accessoryType = .disclosureIndicator
        
        addSubview(iconImageView)
        let iconImageSize = contentView.frame.height-8
        iconImageView.centerY(inView: self)
        iconImageView.anchor(left: leftAnchor, paddingLeft: 4)
        iconImageView.setDimensions(height: iconImageSize, width: iconImageSize)
        iconImageView.layer.cornerRadius = iconImageSize/2
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: iconImageView)
        titleLabel.anchor(left: iconImageView.rightAnchor, right: rightAnchor, paddingLeft: 4, paddingRight: 16)
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel){
        titleLabel.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL)
    }
    
}
