//
//  UserProfile.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let emai: String
    let explicit_content: [String:Int]
    let external_urls: [String: String]
//    let followers: [String: String]
    let id: String
    let product: String
    let images: [UserImage]
    
}

struct UserImage: Codable {
    let url: String
}





