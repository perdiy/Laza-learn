//
//  Detail Products.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//


import Foundation

struct DetailProduct: Codable {
    let status: String
    let isError: Bool
    let data: DataDetailProduct
}

struct DataDetailProduct: Codable {
    let id: Int
    let name, description, imageURL: String
    let price: Double
    let categoryID: Int
    let category: [Category]
    let size: [Size]
    let reviews: [Review]
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "image_url"
        case price
        case categoryID = "category_id"
        case category, size, reviews
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let category: String
}

// MARK: - Review
struct Review: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let fullName: String
    let imageURL: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case fullName = "full_name"
        case imageURL = "image_url"
        case createdAt = "created_at"
    }
}


