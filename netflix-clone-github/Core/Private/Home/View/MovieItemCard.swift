//
//  MovieItemCard.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import SwiftUI
import Kingfisher

struct MovieItemCard: View {
    var movie: MovieItem
    var onTap: (_ movieItem: MovieItem) -> Void

    var body: some View {
        KFImage(movie.posterURL)
            .placeholder { progress in
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(1.5)
            }
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .onTapGesture {
                onTap(movie)
            }
    }
}
