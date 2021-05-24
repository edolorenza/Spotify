//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
       
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let model):
                break
            }
        }
    }
    



}
