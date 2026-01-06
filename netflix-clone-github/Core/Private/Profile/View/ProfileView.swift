//
//  ProfileView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 04/01/26.
//

import SwiftUI
import PhotosUI
import Kingfisher
import ToastUI

struct ProfileView: View {
    @State var authVM: AuthVM
    @State private var imageData: Data?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            Color.profileBG
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                ZStack(alignment: .bottomTrailing) {
                    
                    RoundedRectangle(cornerRadius: 60)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 120)
                    
                    // Image
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    } else if let imageURL = authVM.user?.avatarUrl {
                        KFImage(URL(string: imageURL))
                            .placeholder {
                                ProgressView()
                                    .tint(.white)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    } else {
                        // Placeholder
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.white)
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                            .overlay {
                                Image(systemName: "pencil")
                            }
                    }
                    .padding(.bottom, -10)
                    .padding(.trailing, -10)
                }
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: .init(lineWidth: 0.5))
                    .frame(height: 90)
                    .foregroundStyle(.white.opacity(0.3))
                    .overlay {
                        VStack(alignment: .leading) {
                            Text("Profile Name")
                                .foregroundStyle(.secondary)
                            TextField(
                                "",
                                text: Binding(get: {
                                    $authVM.wrappedValue.user?.fullName ?? ""
                                }, set: { value in
                                    $authVM.wrappedValue.user?.fullName = value
                                }),
                                prompt: Text("John Doe").foregroundStyle(
                                    .white.opacity(0.5)
                                )
                            )
                            .font(.title)
                            .foregroundStyle(.white)
                        }
                        .padding(20)
                    }
                
                VStack(spacing: 12) {
                    ButtonNetflix(
                        text: "Save",
                        configuration: .init(
                            backgroundColor: .white,
                            textConfiguration: .init(
                                font: .headline,
                                fontWeight: .bold,
                                foregroundColor: .black
                            )
                        ),
                        action: {
                            if let user = authVM.user {
                                Task {
                                    await authVM.updateProfile(for: user)
                                }
                            }
                            
                        }
                    )
                    
                    ButtonNetflix(
                        text: "Sign Out",
                        configuration: .init(
                            backgroundColor: .netflixRed,
                            textConfiguration: .init(
                                font: .headline,
                                fontWeight: .bold
                            )
                        ),
                        action: {
                            Task {
                                await authVM.signout()
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 40)
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    imageData = data
                    await authVM.uploadAvatar(image: data)
                }
            }
        }
    }
}

#Preview {
    ProfileView(authVM: AuthVM(service: AuthService(), toast: ToastManager.shared))
}
