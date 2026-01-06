//
//  OnboardingItemView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI

struct OnboardingItemView: View {
    var onboardingModel: OnboardingItem
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Image(onboardingModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                VStack(spacing: 12) {
                    Text(onboardingModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(onboardingModel.subText)
                        .foregroundStyle(.white)
                    VStack(spacing: 0) {
                        Text("Create a Netflix account and more at")
                            .foregroundStyle(.white)
                        Button("netflix.com/more") {
                        }
                        .foregroundStyle(.blue)
                    }
                    .font(.body)
                     .multilineTextAlignment(.center)
                } 
                .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    OnboardingItemView(
        onboardingModel: OnboardingItem(
            title: "Watch Everywhere",
            subText: "Stream on your phone, tablet, laptop, or TV - it's all here.",
            image: .onboarding1,
            tag: 0
        )
    )
}
