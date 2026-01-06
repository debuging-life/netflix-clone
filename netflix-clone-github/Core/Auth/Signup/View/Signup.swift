//
//  Signup.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 02/01/26.
//

import SwiftUI
import SwiftUINavigation


import SwiftUI
import SwiftUINavigation
import ToastUI

struct Signup: View {
    @Environment(\.authCoordinator) var authCoordinator
    @State var authVM: AuthVM
    
    @State  var authModel: AuthModel = AuthModel()
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                TextField(
                    "",
                    text: $authModel.email,
                    prompt: Text("Email or phone number")
                        .foregroundStyle(.white)
                )
                .keyboardType(.emailAddress)
                .frame(maxWidth: .infinity)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(.customDarkGray)
                .foregroundStyle(.white)
                .cornerRadius(4)
                .disabled(authVM.loading)
                
                if showPassword {
                    TextField(
                        "",
                        text: $authModel.password,
                        prompt: Text("Password")
                            .foregroundStyle(.white)
                    )
                    .overlay {
                        VStack {
                            Button {
                                showPassword = false
                            } label: {
                                Image(systemName: "eye.slash")
                            }

                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .keyboardType(.emailAddress)
                    .frame(maxWidth: .infinity)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.customDarkGray)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
                    .disabled(authVM.loading)
                } else {
                    SecureField(
                        "",
                        text: $authModel.password,
                        prompt: Text("Password").foregroundStyle(.white)
                    )
                    .overlay {
                        VStack {
                            Button {
                                showPassword = true
                            } label: {
                                Image(systemName: "eye")
                            }

                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.customDarkGray)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
                    .disabled(authVM.loading)
                }
                
                ButtonNetflix(text: "SIGN UP", disabled: authVM.loading, icon: {
                    if authVM.loading {
                        ProgressView()
                            .tint(.white)
                    }
                }, action: {
                    Task {
                        await authVM.signup(for: authModel, coordinator: authCoordinator)
                    }
                })
                .padding(.top)
                
                Text("OR")
                    .foregroundStyle(.white.opacity(0.5))
                
                HStack {
                    Text("Already have an account?")
                    Button("Sign In") {
                        authCoordinator.navigateBack()
                    }
                }
                .foregroundStyle(.white)
               
            }
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    Signup(
        authVM: AuthVM(service: AuthService(), toast: ToastManager.shared)
    )
}
