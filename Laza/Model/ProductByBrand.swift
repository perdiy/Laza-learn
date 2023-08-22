//
//  ProductByBrand.swift
//  Laza
//
//  Created by Perdi Yansyah on 22/08/23.
//

import Foundation

// MARK: - Brand Product
typealias brandIndex = brandResponse?
struct brandResponse: Codable {
    let status: String
    let isError: Bool
    let data: brandEntry
}

struct brandEntry: Codable {
    let id: Int
    let name: String
    let logo_url: String
    let deleted_at: String?
}



// MARK: - Product by ID Brand
typealias productByIdBrandIndex = prudctByIdBrandResponse?
struct prudctByIdBrandResponse: Codable {
    let status: String
    let isError: Bool
    let data: [prodByIdBrandEntry]!
    
    enum CodingKeys: String, CodingKey {
        case status
        case isError = "isError"
        case data
    }
} 

// MARK: - prodByIdBrandEntry
struct prodByIdBrandEntry: Codable {
    let id: Int
    let name, description: String
    let imageURL: String
    let price, brandID: Int
    let size: JSONNull!
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "image_url"
        case price
        case brandID = "brand_id"
        case size
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
