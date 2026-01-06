//
//  OnboardingView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI
import ToastUI

struct OnboardingView: View {
    @State var index: Int = 0
    @State var showOnboardingConfiramtion: Bool = false
    @AppStorage("onboardingCompleted") var onboardingCompleted: Bool = false
    let onboardingData = OnboardingItem.onboardingData
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                HStack {
                    NetflixLogoView()
                    Spacer()
                    InformationLinks(textColor: .white)
                }
                PageView(
                    currentPage: $index,
                    pages: onboardingData.count,
                    onComplete: { value in
                        showOnboardingConfiramtion = true
                    }
                    
                ) {
                    ForEach(onboardingData) { item in
                        OnboardingItemView(onboardingModel: item)
                            .tag(item.tag)
                    }
                }
                ButtonNetflix(
                    text: "Sign In") {
                        print("Singing in screen")
                    }
                    .padding(.bottom)
            }
            .padding(.horizontal, 24)
        }
        .dialog(isPresented: $showOnboardingConfiramtion) {
            VStack(spacing: 8) {
                Text("If you don't want to show onboarding on next launch press YES otherwise press NO")
                    .multilineTextAlignment(.center)
                HStack {
                    ButtonNetflix(text: "Yes") {
                        Image(systemName: "checkmark.app.fill")
                            .foregroundColor(.white)
                    } action: {
                        onboardingCompleted = true
                        showOnboardingConfiramtion = false
                    }

                    ButtonNetflix(text: "No") {
                        Image(systemName: "x.circle.fill") 
                            .foregroundColor(.white)
                    } action: {
                        showOnboardingConfiramtion = false
                    }
                }
                
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    OnboardingView()
}
