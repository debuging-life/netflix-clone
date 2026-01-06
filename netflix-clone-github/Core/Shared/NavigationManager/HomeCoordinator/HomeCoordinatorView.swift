//
//  HomeCoordinatorView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import SwiftUI
import SwiftUINavigation


struct HomeCoordinatorView: View {
    var movieVM: MovieVM
    var body: some View {
        CoordinatorView(
            environmentKeyPath: \.homeCoordinator,
            rootView: {
                HomeView(movieVM: movieVM)
            },
            destinationBuilder: { destination in
                switch destination {
                case .movieDetails(let id):
                   MovieDetails(id: id)
                }
            }
        )
    }
}
