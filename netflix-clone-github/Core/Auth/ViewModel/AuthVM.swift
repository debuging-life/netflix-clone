//
//  AuthVM.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 04/01/26.
//

import Foundation
import ToastUI
import Supabase
import SwiftUINavigation

@Observable
class AuthVM {
    var service: AuthServiceProtocol
    var toast: ToastManager
    
    var user: ProfileModel?
    var isAuthenticated: Bool  = false
    
    var loading: Bool = false
 
    init(service: AuthServiceProtocol, toast: ToastManager) {
        self.service = service
        self.toast = toast
        
        Task {
            await listenAuthChanges()
        }
    }
     
    func listenAuthChanges() async {
        for await (event, session) in  clientSupabase.auth.authStateChanges {
            switch event {
            case .initialSession:
                if let session = session, !session.isExpired {
                    await getProfile(id: "\(session.user.id)")
                    self.isAuthenticated = true
                } else {
                    self.isAuthenticated = false
                    self.user = nil
                }
                
            case .signedIn:
                
                if let session = session, !session.isExpired {
                    await getProfile(id: "\(session.user.id)")
                    self.isAuthenticated = true
                }
            case .signedOut:
                self.isAuthenticated = false
                self.user = nil
            default: break
            }
        }
    }
    
    
    func signin(for formData: AuthModel) async {
        do { 
            self.loading = true
            defer { self.loading = false }
            toast.showProgressOverlay(title: "Singing in...", message: "Please wait for a moment", configuration: .glass)
            try await service.login(for: formData)
            toast.dismissProgressOverlay()
        } catch  {
            if let error =  error as? ApiErrors {
                toast.dismissProgressOverlay()
                toast.error(title: "Auth Error", message: error.errorDescription)
            }
        }
    }
    
    func signup(for formData: AuthModel, coordinator: AuthCoordinator) async {
        self.loading = true
        defer { self.loading = false }
        do {
            try await service.signup(for: formData)
            coordinator.push(.verifyEmail(formData.email))
        } catch  {
            if let error =  error as? ApiErrors {
                toast.error(title: "Auth Error", message: error.errorDescription)
            }
        }
    }
    
    func verifyEmail(email: String, otp: String) async {
        do {
            try await service.verifyEmail(email: email, otp: otp)
            toast.success(title: "Your email is verified 🎉")
        } catch {
            if let error =  error as? ApiErrors {
                toast.error(title: "Auth Error", message: error.errorDescription)
            }
        }
    }
    
    func getProfile(id: String?) async {
        guard let id else {
            toast.error(title: "Auth Error", message: ApiErrors.unknowUser.errorDescription)
            return
        }
        
        self.loading = true
        defer { self.loading = false }
        
        do {
            user = try await service.getProfile(id: id)
        } catch  {
            if let error =  error as? ApiErrors {
                toast.error(title: "Auth Error", message: error.errorDescription)
            }
        }
    }
    
    func updateProfile(for profileData: ProfileModel) async {
        guard let user = user else {
            toast.error(title: "Invalid user", message: "Please login and try again")
            return
        }
        
        self.loading = true
        defer { self.loading = false }
        do {
            try await service.updateProfile(id: user.id, profile: profileData)
        } catch {
            if let error =  error as? ApiErrors {
                toast.error(title: "Auth Error", message: error.errorDescription)
            }
        }
    }
    
    func uploadAvatar(image: Data) async {
        do {
            let url = try await service.uploadAvatar(image: image)
            user?.avatarUrl = url
            
            guard let user = user else {
                throw ApiErrors.unknowUser
            }
            
            await updateProfile(for: user)
            
        } catch  {
            if let error =  error as? ApiErrors {
                toast.error(title: "Auth Error", message: error.errorDescription)
            }
        }
    }
    
    func signout() async {
        self.loading = true
        defer { self.loading = false }
        do {
            try await service.signOut()
            user = nil
        } catch  {
            if let error =  error as? ApiErrors {
                toast.error(title: "Auth Error", message: error.errorDescription)
            }
        }
    }
}
