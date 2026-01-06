//
//  HomeView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 04/01/26.
//

import SwiftUI

struct HomeView: View {
    var movieVM: MovieVM
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    .bgLightGray,
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack {
                TopBar(text: "For Pardip", textColor: .white)
                ScrollView(showsIndicators: false) {
                    MainCardView()
                    VStack {
                        VideoCollectionView(movieVM: movieVM)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .task {
                await movieVM.fetchAllMoviesBySections()
            }
        }
    }
}

//#Preview {
//    HomeView(movieVM: <#MovieVM#>)
//}
