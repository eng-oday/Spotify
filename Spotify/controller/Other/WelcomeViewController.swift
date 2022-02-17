//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
//MARK: - Create Button
    private let SignInBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    //MARK: - Main Func
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
        view.backgroundColor = .systemGreen
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(SignInBtn)
        SignInBtn.addTarget(self, action: #selector(SignInPressed), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        SignInBtn.frame = CGRect(x: 20,
                                 y: view.height-50-view.safeAreaInsets.bottom,
                                 width: view.width-40,
                                 height: 50)
        
    }
    
    
    //MARK: - Sign In Button And Handle
    
    @objc func SignInPressed(){
        
        // object from AuthVC
        let vc = AuthViewController()
        
        // tell the handle Func if request is success
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    private func handleSignIn(success:Bool){
        
        guard success else{
            
            // if not success and exchangeToken or refresh Token is Failure
            let alert = UIAlertController(title: "oops", message: "Something Went Wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert,animated: true)
            return
            
        }
        
        // if Success Close current View and Open Main Vc "tab bar"
        
        let mainTabBarVc = TabBarViewController()
        mainTabBarVc.modalPresentationStyle = .fullScreen
        present(mainTabBarVc, animated: true)
    }


}
