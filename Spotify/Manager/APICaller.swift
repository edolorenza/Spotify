//
//  APICaller.swift
//  Spotify
//
//  Created by Edo Lorenza on 22/05/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    //MARK: - GetCurrentUserProfile
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
    
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - GetAllNewRelease
    public func getAllNewRelease(completion: @escaping ((Result<AllNewReleaseResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AllNewReleaseResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Featured Playlist
    public func getFeaturedPlaylist(completion: @escaping ((Result<FeaturedPlaylistResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/browse/featured-playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get RecommendationGenres
    public func getRecommendationGenres(completion: @escaping ((Result<RecommendationGenresResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationGenresResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Recommendations with genres
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>)) -> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL+"/recommendations?limit=16&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Album Detail
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Playlist Detail
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get All Categories
    public func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                }
                catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Category playlist
    public func getCategoryPlaylist(categori: Category, completion: @escaping (Result<[Playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL+"/browse/categories/\(categori.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                }
                catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    //MARK: - Private
    
    enum HTTPMethod: String{
        case GET
        case POST
    }
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValidToken { token  in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
