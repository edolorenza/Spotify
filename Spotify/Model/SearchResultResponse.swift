//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Edo Lorenza on 01/06/21.
//

import Foundation

struct SearchResultResponse: Codable {
    let albums: SearchAlumResponse
    let artists: SearchArtistResponse
    let tracks: SearchTrackResponse
    let playlists: SearchPlaylistReponse
}

struct SearchAlumResponse: Codable {
    let items: [Album]
}

struct SearchArtistResponse: Codable {
    let items: [Artist]
}

struct SearchTrackResponse: Codable {
    let items: [AudioTrack]
}

struct SearchPlaylistReponse: Codable {
    let items: [Playlist]
}
