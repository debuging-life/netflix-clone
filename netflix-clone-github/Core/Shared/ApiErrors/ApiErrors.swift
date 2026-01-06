//
//  ApiErrors.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 04/01/26.
//

import Foundation


enum ApiErrors: Error {
    case fieldRequired(String)
    case sbError(Error)
    case unknowUser
    case invalidURL
    case invalidServerResponse
    
    var errorDescription: String? {
        switch self {
        case .fieldRequired(let field):
            if field.isEmpty {
                return "Field is required"
            } else {
                return "\(field) field is required"
            }
        case .sbError(let error):
            return "\(error.localizedDescription)"
        case .unknowUser:
            return "Unknown user or ID is not valid"
        case .invalidURL:
            return "Invalid URL"
        case .invalidServerResponse:
            return "Invalid server response"
        }
    }
}
