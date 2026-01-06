//
//  ContentView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI
import ToastUI

struct ContentView: View {
    @State var showSplash: Bool = true
    @State var authVM: AuthVM = AuthVM(service: AuthService(), toast: ToastManager.shared)
    @State var movieVM = MovieVM(movieService: MovieService(), toast: ToastManager.shared)
    @AppStorage("onboardingCompleted") var onboardingCompleted: Bool = false

    var body: some View {
        Group {
            if showSplash {
                NetflixSplashView(showSplash: $showSplash)
                    .transition(.opacity.combined(with: .move(edge: .leading)))
            } else {
                switch onboardingCompleted {
                case true:
                    switch authVM.isAuthenticated {
                    case true:
                        TabView {
                            HomeCoordinatorView(movieVM: movieVM)
                                .tabItem {
                                    Image(systemName: "house")
                                    Text("Home")
                                }
                            ProfileView(authVM: authVM)
                                .tabItem {
                                    Image(systemName: "person")
                                    Text("Profile")
                                }
                        }
                    case false:
                        AuthCoordinatorView(authVM: authVM)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    }
                case false:
                    OnboardingView()
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }

            }
        }
        .animation(.easeIn(duration: 0.5), value: showSplash)
    }
}

#Preview {
    ContentView()
}
