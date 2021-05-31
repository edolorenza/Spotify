//
//  FeaturedPlaylist.swift
//  Spotify
//
//  Created by Edo Lorenza on 25/05/21.
//

import Foundation


struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistsResponse
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse
}


struct PlaylistsResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

