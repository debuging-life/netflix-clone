//
//  MovieService.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import Foundation

let BASE_URL = "https://api.themoviedb.org"
let THUMBNAIL_BASE_URL = "https://image.tmdb.org/t/p/w500"
let API_KEY = ""

protocol MovieServiceProtocol: Sendable {
    func getMovies(endPoint: APIEndPoints) async throws -> Movie?
    func getMovie(id: Int, type: VideoType) async throws -> MovieItem?
}

struct MovieService: MovieServiceProtocol {
    func getMovies(endPoint: APIEndPoints) async throws -> Movie? {
        guard let url = try getMoviesURLString(endpoint: endPoint) else {
            throw ApiErrors.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Movie.self, from: data)
        } catch {
            throw ApiErrors.invalidServerResponse
        }
        
    }
    
    func getMovie(id: Int, type: VideoType) async throws -> MovieItem? {
        guard let url = try getMovieDetailsURLString(id: id, type: type) else {
            throw ApiErrors.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieItem.self, from: data)
        } catch {
            throw ApiErrors.invalidServerResponse
        }
        
    }
}

extension MovieService {
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApiErrors.invalidServerResponse
        }
    }
    
    private func buildURLComponents() throws -> URLComponents {
        guard var components = URLComponents(string: BASE_URL) else {
            throw ApiErrors.invalidURL
        }
        
        components.path = "/3"
        components.queryItems = [.init(name: "api_key", value: API_KEY)]
        
        return components
    }
    
    private func getMoviesURLString(endpoint: APIEndPoints) throws -> URL? {
        do {
            var components = try buildURLComponents()
            components.path += endpoint.path
            return components.url
        } catch  {
            throw ApiErrors.invalidURL
        }
    }
    
    private func getMovieDetailsURLString(id: Int, type: VideoType) throws -> URL? {
        do {
            var components = try buildURLComponents()
            components.path += type == .movie ? "/movie/\(id)" : "/tv/\(id)"
            components.queryItems?.append(.init(name: "append_to_response", value: "videos"))
            return components.url
        } catch  {
            throw ApiErrors.invalidURL
        }
    }
}



enum APIEndPoints: String, Sendable {
    case nowPlaying = "/movie/now_playing"
    case popular = "/movie/popular"
    case topRated = "/movie/top_rated"
    case upcoming = "/movie/upcoming"
    case tv = "/tv/top_rated"
    case tvToday = "/tv/airing_today"
    
    var path: String { rawValue }
}


enum VideoType {
    case movie
    case tv
}

