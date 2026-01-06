//
//  NetflixSplashView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI

struct NetflixSplashView: View {
   
    @Binding var showSplash: Bool
    
    @State private var isAnimating: Bool = false
    @State private var viewScale: CGFloat = 1.0
    @State private var opacity: Double = 0
    
    let letters = Array("NETFLIX")
   
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            HStack {
                ForEach(letters.enumerated(), id: \.offset) {
                    index,
                    letter in
                    Text(String(letter))
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.9, green: 0.05, blue: 0.05),
                                    Color(red: 0.6, green: 0.0, blue: 0.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .opacity(isAnimating ? 1 : 0)
                        .scaleEffect(isAnimating ? 1 : 0.3)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.7)
                            .delay(Double(index) * 0.1),
                            value: isAnimating
                        )
                }
            }
            .scaleEffect(viewScale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                opacity = 1
            }
            
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.9)) {
                    viewScale = 2
                    opacity = 0
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    NetflixSplashView(showSplash: .constant(false))
}
