//
//  HomeDestinations.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import SwiftUI
import SwiftUINavigation


enum HomeDestinations: Hashable {
    case movieDetails(id: String)
}

typealias HomeCoordinator = NavigationCoordinator<HomeDestinations>

extension EnvironmentValues {
   @Entry var homeCoordinator: HomeCoordinator  = HomeCoordinator()
}
