//
//  AuthDestinations.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 02/01/26.
//

import SwiftUI
import SwiftUINavigation

enum AuthDestinations: Hashable {
    case signin
    case signup
    case verifyEmail(String)
}

typealias AuthCoordinator = NavigationCoordinator<AuthDestinations>

extension EnvironmentValues {
    @Entry var authCoordinator = AuthCoordinator()
}


