//
//  VerifyEmail.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 02/01/26.
//

import SwiftUI

struct VerifyEmail: View {
    var email: String
    var authVM: AuthVM
    @Environment(\.authCoordinator) var router
    @Environment(\.toast) var toast
    
    
    @State var isInvalid: Bool = false
    @State var code: String = ""
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(
                        red: 0.0,
                        green: 0.0,
                        blue: 0.0
                    ),
                    Color(
                        red: 0.2431372549,
                        green: 0.0,
                        blue: 0.0
                    ),
                    Color(
                        red: 0.2431372549,
                        green: 0.0,
                        blue: 0.0
                    ),
                    Color(
                        red: 0.0,
                        green: 0.0,
                        blue: 0.0
                    ),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Text("OTP for email \(email)")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                VerificationField(
                    type: .six,
                    isInValid: $isInvalid,
                    isLoading: false,
                    onChange: { value in
                    },
                    onComplete: { value in
                        print("final value", value)
                        // api call here
                        code = value
                        Task {
                            await authVM.verifyEmail(email: email, otp: value)
                        }
                    },
                    configuration: .init(
                        colors: .init(
                            typing: .white,
                            active: .white,
                            valid: .green,
                            invalid: .red,
                            text: .white,
                            loadingText: .white.opacity(0.5)
                        ),
                        sizes: .init(
                            spacing: 10,
                        )
                    )
                )
            }
            
        }
    }
}

#Preview {
//    VerifyEmail(email: "", authVM: AuthV)
}
