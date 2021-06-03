//
//  ActionLabelView.swift
//  Spotify
//
//  Created by Edo Lorenza on 03/06/21.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}
class ActionLabelView: UIView {
    //MARK: - Properties
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        
        return button
    }()
    
    weak var delegate: ActionLabelViewDelegate?
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    //MARK: - Actions
    @objc func didTapButton(){
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    //MARK: - Helpers
    private func setupView(){
        
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.centerX(inView: label)
        button.anchor(top: label.bottomAnchor, paddingTop: 16)
    }
    
    func configure(with viewModel: ActionLabelViewViewModel){
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
}
