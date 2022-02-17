//
//  AuthViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    
    //MARK: - Create WebView
    private let webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    //MARK: - Public Closure and Main Func
    public var completionHandler: ((Bool)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.Shared.singleURl else {
            return
        }
        webView.load(URLRequest(url: url))
  

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        webView.frame = view.bounds
    }
    
    //MARK: - Get Code Value From WebView And Pop VC and set completion
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        // get the url was opened in webview
        guard let url = webView.url else {
            return
        }
        
    // get the code value from URL
       let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code"})?.value else{
            return
        }
        // Hidden WebView After Login
        webView.isHidden = true
        
        // Exchange Code To token by pass code value to method in Auth Manager, and, pop VC
        
        AuthManager.Shared.exchangecodeForToken(code: code) { [weak self] success in
            
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                
                // the status of func Request If Success or Failed
                self?.completionHandler?(success)

            }
            

        }

    }
    


}
