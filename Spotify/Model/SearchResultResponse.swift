//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Oday Dieg on 28/02/2022.
//

import Foundation

struct SearchResultResponse:Codable{
    let albums:SearchAlbumResponse
    let artists: SearchArtistResponse
    let playlists:SearchPlaylistResponse
    let tracks: SearchTracksResponse
}


struct SearchAlbumResponse:Codable{
    let items:[Album]
}

struct SearchPlaylistResponse:Codable{
    let items:[PlayList]
}
struct SearchArtistResponse:Codable{
    let items:[Artist]
}
struct SearchTracksResponse:Codable{
    let items:[AudioTracks]
}
