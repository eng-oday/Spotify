//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        APIcaller.shared.getCurrentUserProfile { result in
            
            switch result
            {
            case .success(let model):
                break
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    

}
