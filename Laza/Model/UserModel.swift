//
//  UserModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//
import Foundation

struct LoginToken: Codable {
    let status: String
    let isError: Bool
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let fullName, username, email: String
    let isVerified: Bool
//    let imageUrl: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case username, email
//        case imageUrl = "image_url"
        case isVerified = "is_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
