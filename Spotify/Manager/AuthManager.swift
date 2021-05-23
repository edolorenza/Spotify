//
//  AuthManager.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    struct Constants {
        static let clientID = "e247539f8c514bedb027552700f55dde"
        static let clientSecret = "d84c65295b324344b05c94eb44e96d35"
    }
    
    public var signInUrl: URL? {
        let baseUrl = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectUrl = "https://www.edolorenza.me"
        let string = "\(baseUrl)?response_type=code&client_id=\(Constants.clientID)&scopes=\(scopes)?&redirect_uri=\(redirectUrl)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool { return false }
    
    private var accessToken: String? { return nil }
    private var refreshToken: String? { return nil }
    private var tokenExpirationDate: Date? { return nil }
    private var shouldRefreshToken: Bool { return false }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void){
        
    }
    
    public func refreshAccessToken(){
        
    }
    
    private func cacheToken(){
        
    }
}
