//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Edo Lorenza on 31/05/21.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let href: String
    let id: String
    let name: String
    let icons: [APIImage]
}
