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

struct PlaylistsResponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

