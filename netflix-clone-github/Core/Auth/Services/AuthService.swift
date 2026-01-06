//
//  AuthService.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 04/01/26.
//

import Foundation
import Supabase

protocol AuthServiceProtocol {
    func login(for formData: AuthModel?) async throws
    func signup(for formData: AuthModel?) async throws
    func verifyEmail(email: String, otp: String) async throws
    func getProfile(id: String) async throws -> ProfileModel?
    func updateProfile(id: String, profile: ProfileModel) async throws
    func uploadAvatar(image: Data) async throws -> String?
    func isAuthenticated() -> Bool
    func signOut() async throws
}

struct AuthService: AuthServiceProtocol {
    func login(for formData: AuthModel?) async throws {
        guard let email = formData?.email, let password = formData?.password else {
            throw ApiErrors.fieldRequired("Input")
        }
        
        do {
            try await clientSupabase.auth
                .signIn(email: email, password: password)
        } catch  {
            throw ApiErrors.sbError(error)
        }
    }
    
    func signup(for formData: AuthModel?) async throws {
        guard let email = formData?.email, let password = formData?.password else {
            throw ApiErrors.fieldRequired("Input")
        }
        
        do {
            try await clientSupabase.auth
                .signUp(email: email, password: password)
        } catch  {
            throw ApiErrors.sbError(error)
        }
    }
    
    func verifyEmail(email: String, otp: String) async throws {
        do {
            try await clientSupabase.auth
                .verifyOTP(email: email, token: otp, type: .email)
        } catch  {
            throw ApiErrors.sbError(error)
        }
    }
    
    func getProfile(id: String) async throws -> ProfileModel? {
        do {
            let users: [ProfileModel] = try await clientSupabase.from("profiles").select().eq(
                "id",
                value: id
            ).execute().value
            print(users)
            return users.first
        } catch  {
            throw ApiErrors.sbError(error)
        }
    }
    
    func updateProfile(id: String, profile: ProfileModel) async throws {
        do {
            try await clientSupabase
                .from("profiles")
                .update(profile)
                .eq("id", value: id)
                .execute()
        } catch {
            throw ApiErrors.sbError(error)
        }
    }
    
    func uploadAvatar(image: Data) async throws -> String? {
        let bucketName = "profiles"
        let fileName = UUID().uuidString + ".jpg"
        let path = "public/\(fileName)"
        
        do {
            try await clientSupabase.storage.from(bucketName)
                .upload(path, data: image)
            
            let publicURL = try clientSupabase.storage
              .from(bucketName)
              .getPublicURL(path: path)
            return publicURL.absoluteString    
        } catch {
            throw ApiErrors.sbError(error)
        }
        
    }
    
    func isAuthenticated() -> Bool {
        clientSupabase.auth.currentUser != nil
    }
    
    func signOut() async throws {
        do {
            try await clientSupabase.auth.signOut()
        } catch {
            throw ApiErrors.sbError(error)
        }
    }
}
