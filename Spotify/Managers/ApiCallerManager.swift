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
    
    
    //MARK: - Generic func Used IN API
    
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
    
    //  generic decode func by me 
    
    private func CreateTaskAndDecodeData<T>(request:URLRequest,ModelType:T.Type,completion: @escaping((Result<T,Error>))->Void) where T : Codable{

        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            guard let data = data , error == nil else{
                completion(.failure(APiError.failedTogetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(ModelType , from: data)
               completion(.success(result))

            }catch{
                completion(.failure(error))
            }
        }
        task.resume()

    }
    
    
    //MARK: - Album
    
    public func GetAlbumDetails(album:Album , completion : @escaping (Result<AlbumDetailsResponse,Error>)->Void){
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/albums/" + album.id), Type: .GET) { request in
            
            self.CreateTaskAndDecodeData(request: request, ModelType: AlbumDetailsResponse.self) { result in

                switch result{
                case .success(let data):
                    completion(.success(data))
                case.failure(let error):
                    completion(.failure(error))
                }

            }
 
            
 
        }
        
        
    }
    //MARK: - Playlist
    public func GetAlbumDetails(playList:PlayList , completion : @escaping (Result<PlayListDetailsResponse,Error>)->Void){
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/playlists/" + playList.id), Type: .GET) { request in
            
            self.CreateTaskAndDecodeData(request: request, ModelType: PlayListDetailsResponse.self) { result in

                switch result{
                case .success(let data):
                    completion(.success(data))
                case.failure(let error):
                    completion(.failure(error))
                }

            }

 
        }
        
        
    }
        
    //MARK: - get user profile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>)->Void){
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/me"),
                      Type: .GET)
        { request in
            
            self.CreateTaskAndDecodeData(request: request, ModelType: UserProfile.self) { result in
                
                switch result{
                case .success(let data):
                    completion(.success(data))
                case.failure(let error):
                    completion(.failure(error))
                }
                
            }
            
        }
        
    }
    
    //MARK: - Browse Home Api
    
    
    public func GetNewRelases (completion: @escaping ((Result<NewRelasesResponse,Error>)) -> Void){
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/browse/new-releases?limit=50"), Type: .GET) { request in
//
            
            
            
            
            self.CreateTaskAndDecodeData(request: request, ModelType: NewRelasesResponse.self) { result in
                
                switch result{
                case .success(let data):
                    completion(.success(data))
                case.failure(let error):
                    completion(.failure(error))
                }
                
            }

        }
        
    }
    
    public func GetFeaturedPlaylist( completion: @escaping((Result<FeaturedPlayListResponse,Error>))->Void){
        
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/browse/featured-playlists?limit=50"), Type: .GET) { request in
            
            
            
            self.CreateTaskAndDecodeData(request: request, ModelType: FeaturedPlayListResponse.self) { result in
                
                switch result{
                case .success(let data):
                    completion(.success(data))
                case.failure(let error):
                    completion(.failure(error))
                }
                
            }
    
        }
    }
    
    public func GetGenreRecomendations( completion: @escaping((Result<RecomndedGenresResponse,Error>))->Void){
        
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/recommendations/available-genre-seeds?limit=50"), Type: .GET) { request in
            
            
            self.CreateTaskAndDecodeData(request: request, ModelType: RecomndedGenresResponse.self) { result in
                
                switch result{
                case .success(let data):
                    completion(.success(data))
                case.failure(let error):
                    completion(.failure(error))
                }
                
            }

        }
    }
    
    public func GetRecomendations(geners:[String] , completion: @escaping((Result<RecomendationsResponse,Error>))->Void){
        
      let seeds = geners.joined(separator: ",")
        
        CreateRequest(url: URL(string: Constants.baseApiUrl + "/recommendations?limit=15&seed_genres=\(seeds)"), Type: .GET) { request in
                        
            self.CreateTaskAndDecodeData(request: request, ModelType: RecomendationsResponse.self) { result in
                
                switch result{
                case .success(let data):
                    completion(.success(data))
                case.failure(let error):
                    completion(.failure(error))
                }
                
            }
            
        }
    }
}







//MARK: - old Code before create generic func to decode

// repeat this code in every API request only the change is model type xxxxxxxx

//CreateRequest(url: URL(string: Constants.baseApiUrl + "/recommendations?limit=1&seed_genres=\(seeds)"), Type: .GET) { request in
//
//                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
//
//                        guard let data = data , error == nil else{
//                            completion(.failure(APiError.failedTogetData))
//                            return
//                        }
//                        do{
//                            let result = try JSONDecoder().decode(RecomendationsResponse.self, from: data)
//                           completion(.success(result))
//
//                        }catch{
//                            completion(.failure(error))
//                            print("error to get featured albums")
//
//                        }
//                    }
//                    task.resume()
//
//}

