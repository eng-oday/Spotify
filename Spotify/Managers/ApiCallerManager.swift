//
//  ApiCaller.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import Foundation

final class APIcaller {
    
    static let shared = APIcaller()
    
    enum httpMethod: String{
        case GET
        case POST
    }
    
    struct Constants {
                static let baseApiUrl = "https://api.spotify.com/v1"
            }
    
    enum APiError: Error {
        case failedTogetData
    }
    
    
    private init(){}
    
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>)->Void){
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/me"),
                      Type: .GET)
        { baseRequest in
            
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                
                guard let data = data , error == nil else{
                    completion(.failure(APiError.failedTogetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                    completion(.success(result))
                    
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))                    
                }
            }
            task.resume()
            
            
        }
        
    }
    
    
    private func CreateRequest(url: URL? ,
                               Type: httpMethod,
                               completion: @escaping ((URLRequest)->Void))
    {
        AuthManager.Shared.WithValidToken { Token in
            guard let APIurl = url else{
                return
            }
            
            var Request = URLRequest(url: APIurl)
            Request.setValue("Bearer \(Token)", forHTTPHeaderField: "Authorization")
            Request.httpMethod = Type.rawValue
            Request.timeoutInterval = 30
            completion(Request)
            
            
        }
        
        
        
    }
    
    
    
    
}
