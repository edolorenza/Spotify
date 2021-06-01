//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Edo Lorenza on 01/06/21.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func PlayerControlsViewDidTapPlayPause(_ playerControlView: PlayerControlsView)
    func PlayerControlsViewDidTapBackwardButton(_ playerControlView: PlayerControlsView)
    func PlayerControlsViewDidTapForwardButton(_ playerControlView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    //MARK: - Properties
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let songTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Ketika Ku Menemukanmu"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.text = "Ariel Noah"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Actions
    @objc func didTapBack() {
        delegate?.PlayerControlsViewDidTapBackwardButton(self)
    }
    
    @objc func didTapPlayPause() {
        delegate?.PlayerControlsViewDidTapPlayPause(self)
    }
    
    @objc func didTapNext() {
        delegate?.PlayerControlsViewDidTapForwardButton(self)
    }
    
    
    //MARK: - Helpers
    private func setupView(){
        backgroundColor = .systemBackground
        clipsToBounds = true
        addSubview(songTitleLabel)
        songTitleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        addSubview(subtitleLabel)
        subtitleLabel.anchor(top: songTitleLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        addSubview(volumeSlider)
        volumeSlider.anchor(top: subtitleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16,  paddingLeft: 16, paddingRight: 16)
        
        let stack = UIStackView(arrangedSubviews: [backButton, playPauseButton, nextButton])
        addSubview(stack)

        let buttonSize: CGFloat = 60
        backButton.setDimensions(height: buttonSize, width: buttonSize)
        nextButton.setDimensions(height: buttonSize, width: buttonSize)
        playPauseButton.setDimensions(height: buttonSize, width: buttonSize)

        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 16
        stack.centerX(inView: self)
        stack.anchor(top: volumeSlider.bottomAnchor, paddingTop: 16)
        
    }
}
