//
//  UserProfile.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import Foundation

struct UserProfile:Codable{
    
    let country: String
    let display_name: String
    let email: String
    let explicit_content : [String:Bool]
    let external_urls: [String:String]
    let href: String
    let id: String
    let product: String
    let images: [ApiImage]

}

