//
//  UserProfile.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import Foundation

struct UserProfile:Codable{
    
    let country:String
    let display_name:String
    let email:String
    let explicit_content : [String:Int]
    let external_urls: [String:String]
   // let followers: [String:Codable?]
    let href: String
    let id: String
    let product: String
    let images: [UserImage]
    
    
}

struct UserImage:Codable{
    
    let url:String
}

