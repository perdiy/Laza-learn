//
//  Login.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//

import Foundation

struct Login: Codable {
    let status: String
    let isError: Bool
    let data: LoginData
}

struct LoginData: Codable {
    let id: Int
    let username, password, email, fullName: String
    let imageURL: String
    let isVerified: Bool
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, username, password, email
        case fullName = "full_name"
        case imageURL = "image_url"
        case isVerified = "is_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

