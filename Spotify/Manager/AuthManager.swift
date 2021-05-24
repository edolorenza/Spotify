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
        static let clientSecret = "bc3c205fdac44209a46a2859589c8ffe"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectUrl = "https://www.edolorenza.me"
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
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void) ) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectUrl),
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }

        request.setValue("Basic \(base64String)",
                         forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }

            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(result)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken(){
        
    }
    
    private func cacheToken(){
        
    }
}
