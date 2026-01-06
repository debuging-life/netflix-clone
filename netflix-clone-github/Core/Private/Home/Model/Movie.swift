//
//  Movie.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import Foundation


struct Movie: Codable, Sendable {
    let results: [MovieItem]
}

struct MovieItem: Codable, Identifiable {
    let id: Int
    let title: String?
    let name: String?
    let overview: String
    let posterPath: String?
    let videos: ResultVideo?
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(THUMBNAIL_BASE_URL)\(posterPath)")
    }
}


struct ResultVideo: Codable {
    let results: [Results]?
}

struct Results: Codable {
    let key: String
}

struct MovieSection: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let endpoint: APIEndPoints
    var movies: [MovieItem]
    
    init(title: String, endpoint: APIEndPoints, movies: [MovieItem] = []) {
        self.title = title
        self.endpoint = endpoint
        self.movies = movies
    }
}
