//
//  NetflixLogoView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI

import SwiftUI

struct NetflixLogoView: View {
    let text: String = "NETFLIX"
    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.9, green: 0.05, blue: 0.05),
                                Color(red: 0.7, green: 0.0, blue: 0.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .offset(y: calculateOffset(for: index))
            }
        }
    }
     
    private func calculateOffset(for index: Int) -> CGFloat {
        let center = Double(text.count) / 2
        let distance = Double(index) - center
        
        return CGFloat(distance * distance * 0.3)
    }
}

#Preview {
    NetflixLogoView()
}
