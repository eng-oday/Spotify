//
//  GategoryResponse.swift
//  Spotify
//
//  Created by Oday Dieg on 27/02/2022.
//

import Foundation


struct CategoryResponse:Codable {
    
    let categories:categories
    
}

struct categories :Codable{
    let items:[Category]
}

struct Category:Codable{
 
    let href:String
    let icons:[ApiImage]
    let id:String
    let name:String
    
}
