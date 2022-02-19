//
//  PlayListModel.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import Foundation

struct PlayList:Codable{
    let description:String
    let external_urls: [String:String]
    let id : String
    let images:[ApiImage]
    let name:String
    let owner:User
    
}
