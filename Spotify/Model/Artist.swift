//
//  Artist.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import Foundation

struct Artist:Codable{
    let external_urls: [String:String]
    let id:String
    let name:String
    let type:String
    
}
