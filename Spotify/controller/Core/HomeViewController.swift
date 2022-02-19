//
//  ViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))

        
        
        Fetchdata()
    }

    
    
    
    
    private func Fetchdata(){
        
        APIcaller.shared.GetGenreRecomendations(completion: { result in
            
            switch result {
                
            case.success(let data):
                let genres = data.genres
                var seeds = [String]()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.append(random)

                    }
                }
                APIcaller.shared.GetRecomendations(geners: seeds) { _ in
                    
                    print("am hereeeeeee")
                }
                
                
            case.failure(let error): break
                
            }
            
        })
        
    }
    
    @objc func didTapSettings(){
        
        let vc = SettingViewController()
        vc.title = "settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
    }

}

