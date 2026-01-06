//
//  MainCardView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import SwiftUI
import Kingfisher

struct MainCardView: View {
    var body: some View {
        VStack {
            ZStack {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500/udAxQEORq2I5wxI97N2TEqdhzBE.jpg"))
                    .placeholder({
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.blue)
                    })
                    .resizable()
                    .scaledToFill()
                    .frame(height: 500)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                LinearGradient(
                    colors: [
                        .clear,
                        .black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                VStack {
                    Spacer()
                    
                    HStack {
                        ButtonNetflix(
                            text: "Play",
                            configuration: .init(
                                backgroundColor: .white,
                                textConfiguration: .init(
                                    foregroundColor: .black
                                )
                            ),
                            icon: {
                                Image(systemName: "play")
                                    .font(.title3)
                                    .foregroundStyle(.black)
                            }
                        ) {
                            
                        }
                        
                        ButtonNetflix(
                            text: "My List",
                            configuration: .init(
                                backgroundColor: .buttonGrayDark
                            ),
                            icon: {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .foregroundStyle(Color(.white))
                            }
                        ) {
                            
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                }
            }
        }
        .frame(height: 500)
    }
}

#Preview {
    MainCardView()
}
