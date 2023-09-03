//
//  Login.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//

import Foundation

typealias profileIndex = profileUser?
struct profileUser: Codable {
    let status: String
    let isError: Bool
    let data: DataUseProfile
}
struct DataUseProfile: Codable {
    let id: Int
    let fullName, username, email: String
    let image_url: String
    let isVerified: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case username, email, image_url
        case isVerified = "is_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct LoginResponse: Codable {
    let status: String
    let isError: Bool
    let data: AuthData
}

typealias AuthToken = AuthData?
struct AuthData: Codable {
    let access_token: String
    let refresh_token: String
}


struct refreshTokenResponse: Codable {
    let status: String
    let isError: Bool
    let data: RefreshToken
}

// MARK: - RefreshToken
typealias AuthRefreshToken = RefreshToken?
struct RefreshToken: Codable {
    let access_token: String
    let refresh_token: String
}

struct ResponFailed : Codable {
    let status: String
    let description: String
}
