//
//  ViewModel.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import Foundation
import ToastUI

@Observable
class MovieVM {
    var movieService: MovieService
    var toast: ToastManager
    var movie: MovieItem?
    var sections: [MovieSection] = []
    
    init(movieService: MovieService, toast: ToastManager) {
        self.movieService = movieService
        self.toast = toast
        
        setupSections()
    }
    
    private func setupSections() {
        self.sections = [
            .init(title: "Now Playing", endpoint: .nowPlaying),
            .init(title: "TV Shows", endpoint: .tv),
            .init(title: "TV Airing Today", endpoint: .tvToday),
            .init(title: "Popular on Netflix", endpoint: .popular),
            .init(title: "Top Rated", endpoint: .topRated),
            .init(title: "Coming Soon", endpoint: .upcoming)
        ]
    }
    
    func fetchAllMoviesBySections() async {
        await withTaskGroup(of: (Int, [MovieItem]).self) { group in
            for (index, section) in sections.enumerated() {
                group.addTask {
                    do {
                        let response = try await self.movieService.getMovies(endPoint: section.endpoint)
                        return (index, response!.results)
                    } catch  {
                        return (index, [])
                    }
                }
            }
            
            for await (index, movies) in group {
                sections[index].movies = movies
            }
        }
    }
    
    func fetchMovie(id: Int, type: VideoType) async {
        do {
            toast.showProgressOverlay(title: "Loading...", message: "We are fetching your moivie")
            self.movie = try await movieService.getMovie(id: id, type: type)
            toast.dismissProgressOverlay()
        } catch  {
            if let error = error as? ApiErrors {
                toast.error(title: error.errorDescription!)
            }
            toast.dismissProgressOverlay()
        }
    }
    
}
