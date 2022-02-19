//
//  AuthManager.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import Foundation

final class AuthManager{
    
    //MARK: - Singltone Instance
    static let Shared = AuthManager()
    private var RefreshingToken = false
    
    //MARK: - Constants URls
    struct Constants{
        
        //oday account
        static let ClientId = "7fb70e0147fc4849932733c833e29a8c"
        static let clientSecret = "0476149d8326485887b41511a05aecf1"
        
        //not today account
//        static let ClientId = "743e9406538e461aa6226b966048013c"
//        static let clientSecret = "c8c8ab63d72747f2bf3d19c33103bb8e"
//
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        static let redirectURI = "https://iosacademy.io"
        static let tokenApiurl = "https://accounts.spotify.com/api/token"
    }
    
    //MARK: - Final URL TO use IN WebView For AUTH
    public var singleURl:URL?{
        
         let baseUrl = "https://accounts.spotify.com/authorize"
        let string = "\(baseUrl)?response_type=code&client_id=\(Constants.ClientId)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)"
        
        return URL(string: string)
    }
    
    private init(){
        
    }
    
    //MARK: - Auth Data and Status
    var isSignedIn:Bool{
        return accessToken != nil
    }
    
    
    private var accessToken:String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken:String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate:Date?
    {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken:Bool{
        
        guard let expirationDate = tokenExpirationDate else{
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        
        
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    
    
    //MARK: - Excahnge Code For Token With APi "POST"
    
    public func exchangecodeForToken(
        code: String,
        completion: @escaping ((Bool)->Void)
    ){
        //get TOken
        
        guard let url = URL(string: Constants.tokenApiurl) else{
            return
        }
            
            var component = URLComponents()
            component.queryItems = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: "https://iosacademy.io")
                
            ]
            
            var Request = URLRequest(url: url)
            Request.httpMethod = "POST"
            Request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            Request.httpBody = component.query?.data(using: .utf8)
            
            let basicToken = Constants.ClientId+":"+Constants.clientSecret
            let data = basicToken.data(using: .utf8)
            guard let base46String = data?.base64EncodedString() else {
                print("failure To get base46")
                completion(false)
                return
            }
            Request.setValue("Basic \(base46String)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: Request) {[weak self] data,_, error in
                guard let data = data , error == nil else {
                    completion(false)
                    return
                }
                do{
                    
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self?.casheToken(result: result)
                    print("Success : \(result)")
                    completion(true)
                    
                }catch{
                    completion(false)
                    print("error\(error.localizedDescription)")
                }
                
            }
            task.resume()
            
    
    }
    
        //MARK: - Refresh Token After Expired
    
    private var onRefreshBlocks = [((String)->Void)]()
    
    //Supplies valid token to be used in Api calls
    public func WithValidToken(completion: @escaping (String)->Void){
        
        guard !RefreshingToken else{
            //Append the completion
            onRefreshBlocks.append(completion)
            return
        }
    
        if shouldRefreshToken {
            // refresh
            RefreshIfNeeded { [weak self] success in
                if let Token = self?.accessToken , success{
                    completion(Token)
                }
            }
        }else{
            if let Token = accessToken
            {
                completion(Token)
            }
            
        }
    }
    
    
    public func RefreshIfNeeded(completion:((Bool)-> Void)?){
    
        guard !RefreshingToken else{
            return
        }
        
       //  if return true thats mean not needed to refresh
        guard shouldRefreshToken else{
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }

            //Refresh Token
            guard let url = URL(string: Constants.tokenApiurl) else{
                return
            }
        
        RefreshingToken = true
                
                var component = URLComponents()
                component.queryItems = [
                    URLQueryItem(name: "grant_type", value: "refresh_token"),
                    URLQueryItem(name: "refresh_token", value: refreshToken)
                    
                ]
                
                var Request = URLRequest(url: url)
                Request.httpMethod = "POST"
                Request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                Request.httpBody = component.query?.data(using: .utf8)
                
                let basicToken = Constants.ClientId+":"+Constants.clientSecret
                let data = basicToken.data(using: .utf8)
                guard let base46String = data?.base64EncodedString() else {
                    print("failure To get base46")
                    completion?(false)
                    return
                }
                Request.setValue("Basic \(base46String)", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: Request) {[weak self] data,_, error in
                    self?.RefreshingToken = false
                    guard let data = data , error == nil else {
                        completion?(false)
                        return
                    }
                    do{
                        
                        let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                        self?.onRefreshBlocks.forEach { $0(result.access_token) }
                        self?.onRefreshBlocks.removeAll()
                        self?.casheToken(result: result)
                    }catch{
                        completion?(false)
                        print("error\(error.localizedDescription)")
                    }
                    
                }
                task.resume()
                
        
        }
        
    //MARK: - Cashing the Response Of Tokens Request
    
    public func casheToken(result: AuthResponse){
        
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refreshToken = result.refresh_token {
                        UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        
        
    }
    
}
