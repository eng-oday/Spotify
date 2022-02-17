//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let nav1 = UINavigationController(rootViewController: HomeViewController())
        let nav2 = UINavigationController(rootViewController: SearchViewController())
        let nav3 = UINavigationController(rootViewController: LibraryViewController())
        
        nav1.title = "Browse"
        nav2.title = "Search"
        nav3.title = "Library"
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName:"house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName:"magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName:"music.note.list"), tag: 1)

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true

        
        setViewControllers([nav1,nav2,nav3], animated: false)


    }
    


}
