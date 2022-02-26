//
//  PlayListDetailsResponse.swift
//  Spotify
//
//  Created by Oday Dieg on 23/02/2022.
//

import Foundation

struct PlayListDetailsResponse:Codable{
    
    let description:String
    let external_urls:[String:String]
    let id :String
    let images:[ApiImage]
    let name:String
    let tracks: PlayListTrackResponse
    
}
struct PlayListTrackResponse:Codable{
    
    let items:[playListItem]
}
struct playListItem:Codable{
    let track:AudioTracks
}
