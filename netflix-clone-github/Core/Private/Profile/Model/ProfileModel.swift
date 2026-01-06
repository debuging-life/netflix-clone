//
//  ProfileModel.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 04/01/26.
//

import Foundation

struct ProfileModel: Codable {
    var id: String
    var email: String
    var fullName: String?
    var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case avatarUrl = "avatar_url"
        case fullName = "full_name"
    }
}
