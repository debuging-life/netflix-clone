//
//  MovieDetails.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import SwiftUI

struct MovieDetails: View {
    var id: String
    var body: some View {
        VStack {
           YouTubeView(youtubeID: id)
        }
        .background(.black)
        .ignoresSafeArea()
    }
}

#Preview {
    MovieDetails(id: "")
}
