//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    //MARK: - Properties
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "loginCover")
        return imageView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "whiteLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Millions of songs.\nFree on Spotify."
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        coverImageView.frame = view.bounds
        overlayView.frame = view.bounds
        let logoImageSize = view.frame.width/8
        logoImageView.setDimensions(height: logoImageSize, width: logoImageSize)
        
    }
    
    //MARK: - Helpers
    func setupView() {
        view.addSubview(coverImageView)
        view.addSubview(overlayView)
        view.addSubview(taglineLabel)
        view.addSubview(logoImageView)
        view.addSubview(signInButton)
        
        signInButton.anchor(left: view.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingLeft: 24,
                            paddingBottom: 8,
                            paddingRight: 24,
                            height: 50)
        
        signInButton.layer.cornerRadius = 50/2
        
        logoImageView.centerX(inView: view)
        logoImageView.centerY(inView: view)
        
        taglineLabel.centerX(inView: logoImageView, topAnchor: logoImageView.bottomAnchor, paddingTop: 8)
        
    }
    
    //MARK: - Actions
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}



