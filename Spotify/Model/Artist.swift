//
//  Artist.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
