//
//  SearchResult.swift
//  Spotify
//
//  Created by Oday Dieg on 28/02/2022.
//

import Foundation

enum SearchResult {
    
    case artist(model:Artist)
    case album(model:Album)
    case playlist(model:PlayList)
    case track(model:AudioTracks)
    
    
}
