//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Edo Lorenza on 27/05/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    //MARK: - Properties
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleSectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
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
    
    //MARK: - Helpers
    func configure(with title: String) {
        titleSectionLabel.text = title
    }
    
    private func setupView(){
        addSubview(titleSectionLabel)
        titleSectionLabel.centerY(inView: self)
        titleSectionLabel.anchor(left: leftAnchor, paddingLeft: 8)
    }
}
