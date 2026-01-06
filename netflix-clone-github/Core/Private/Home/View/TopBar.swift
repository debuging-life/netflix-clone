//
//  TopBar.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import SwiftUI

struct TopBar: View {
    var text: String = "For Pardip"
    var textColor: Color = .blue
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(textColor)
            Spacer()
            HStack {
                Image(systemName: "arrow.down.circle.dotted")
                    .font(.title)
                    .foregroundStyle(textColor)
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundStyle(textColor)
            }
        }
    }
}

#Preview {
    TopBar()
}
