//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Edo Lorenza on 01/06/21.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
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
        subtitleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.frame.height-10
        iconImageView.setDimensions(height: imageSize, width: imageSize)
    }
    
    //MARK: - Helpers
    private func setupView() {
        
        self.accessoryType = .disclosureIndicator
        
        addSubview(iconImageView)
        
        iconImageView.centerY(inView: self)
        iconImageView.anchor(left: leftAnchor, paddingLeft: 4)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        addSubview(stack)
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 4
        stack.centerY(inView: iconImageView)
        stack.anchor(left: iconImageView.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 16)
      
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel){
        titleLabel.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"))
        subtitleLabel.text = viewModel.subtitle
    }
    
}
