//
//  ApiCaller.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import Foundation

final class APIcaller {
    
    //MARK: - Main
    static let shared = APIcaller()

    struct Constants {
        static let baseApiUrl = "https://api.spotify.com/v1"
    }
    
    
    enum httpMethod: String{
        case GET
        case POST
    }
  
    enum APiError: Error {
        case failedTogetData
    }
    
    private init(){}
    
    
    //MARK: - Generic func to Create Request
    
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
    
    //MARK: - API Funcs
    
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
                    completion(.success(result))
                    
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))                    
                }
            }
            task.resume()
            
            
        }
        
    }
    
    
    public func GetNewRelases (completion: @escaping ((Result<NewRelasesResponse,Error>)) -> Void){
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/browse/new-releases?limit=50"), Type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                guard let data = data , error == nil else{
                    completion(.failure(APiError.failedTogetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(NewRelasesResponse.self, from: data)
                    completion(.success(result))
                    
                }catch{
                    completion(.failure(error))
                    print("error to get new relases")
                    
                }
            }
            task.resume()
        }
        
    }
    
    public func GetFeaturedPlaylist( completion: @escaping((Result<FeaturedPlayListResponse,Error>))->Void){
        
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/browse/featured-playlists?limit=50"), Type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                guard let data = data , error == nil else{
                    completion(.failure(APiError.failedTogetData))
                    return
                }
                do{
                    let result = try  JSONDecoder().decode(FeaturedPlayListResponse.self, from: data)
              completion(.success(result))
                }catch{
                    completion(.failure(error))
                    print("error to get featured albums")
                    
                }
            }
            task.resume()
        }
    }
    
    public func GetGenreRecomendations( completion: @escaping((Result<RecomndedGenresResponse,Error>))->Void){
        
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/recommendations/available-genre-seeds?limit=50"), Type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                guard let data = data , error == nil else{
                    completion(.failure(APiError.failedTogetData))
                    return
                }
                do{
                    let result = try  JSONDecoder().decode(RecomndedGenresResponse.self, from: data)
                    completion(.success(result))

                }catch{
                    completion(.failure(error))
                    print("error to get featured albums")
                    
                }
            }
            task.resume()
        }
    }
    
    public func GetRecomendations(geners:[String] , completion: @escaping((Result<RecomendationsResponse,Error>))->Void){
        
      let seeds = geners.joined(separator: ",")
        
        
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/recommendations?limit=1&seed_genres=\(seeds)"), Type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in

                guard let data = data , error == nil else{
                    completion(.failure(APiError.failedTogetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecomendationsResponse.self, from: data)
                   completion(.success(result))

                }catch{
                    completion(.failure(error))
                    print("error to get featured albums")

                }
            }
            task.resume()
        }
    }
    
    
 
    // try to get generic decode func
    
//    private func Test<T>(request:URLRequest,ModelType:T.Type,completion: @escaping((Result<Any,Error>))->Void) where T : Codable{
//
//        let task = URLSession.shared.dataTask(with: request) { data, _, error in
//
//            guard let data = data , error == nil else{
//                completion(.failure(APiError.failedTogetData))
//                return
//            }
//            do{
//                let result = try JSONDecoder().decode(ModelType , from: data)
//               completion(.success(result))
//
//            }catch{
//                completion(.failure(error))
//                print("error to get featured albums")
//
//            }
//        }
//        task.resume()
//
//    }
//
    
    
    
    
}
