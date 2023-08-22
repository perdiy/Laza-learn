//
//  Wishlist.swift
//  Laza
//
//  Created by Perdi Yansyah on 22/08/23.
//

import Foundation

// MARK: - Wishlist
struct Wishlist: Codable {
    let status: String
    let isError: Bool
    let data: DataWishlist
}

// MARK: - DataClass
struct DataWishlist: Codable {
    let total: Int
    let products: [ProductWishlist]
}

// MARK: - Product
struct ProductWishlist: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let price: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case price
        case createdAt = "created_at"
    }
}

struct UpdateWishlist: Codable {
    let status: String
    let isError: Bool
    let data: String
}
