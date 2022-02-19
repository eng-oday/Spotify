//
//  FeaturedPlayListResponse.swift
//  Spotify
//
//  Created by Oday Dieg on 19/02/2022.
//

import Foundation

struct FeaturedPlayListResponse : Codable{
    
    let playlists: PlayListResponse
}
struct PlayListResponse:Codable{
    let items: [PlayList]
    
}


struct User:Codable{
    
    let display_name:String
    let external_urls: [String:String]
    let id:String
    
}
