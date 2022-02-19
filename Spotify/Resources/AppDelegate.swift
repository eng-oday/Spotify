//
//  AppDelegate.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var  window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // create Window And Set initial VC Based on Login Status 
        let window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.Shared.isSignedIn {
            window.rootViewController = TabBarViewController()
            AuthManager.Shared.RefreshIfNeeded(completion: nil)
        }else{
            window.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        }
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }




}

