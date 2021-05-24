//
//  AuthResponse.swift
//  Spotify
//
//  Created by Edo Lorenza on 24/05/21.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let scope: String
    let refresh_token: String?
    let token_type: String
}
