//
//  SearchResult.swift
//  Spotify
//
//  Created by Edo Lorenza on 01/06/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
