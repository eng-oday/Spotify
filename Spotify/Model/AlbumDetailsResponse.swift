//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Oday Dieg on 23/02/2022.
//

import Foundation

struct AlbumDetailsResponse: Codable{
    
    let album_type:String
    let artists: [Artist]
    let available_markets:[String]
    let external_urls:[String:String]
    let id :String
    let images:[ApiImage]
    let label:String
    let name:String
    let tracks:TracksResponse
    
    
}
struct TracksResponse:Codable{
    
  let items:[AudioTracks]

}

