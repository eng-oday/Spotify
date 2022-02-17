//
//  SettingModel.swift
//  Spotify
//
//  Created by Oday Dieg on 17/02/2022.
//

import Foundation

struct Section{
    let title:String
    let options:[Option]
}

struct Option{
    
    let title:String
    let handler: ()->Void
    
}
