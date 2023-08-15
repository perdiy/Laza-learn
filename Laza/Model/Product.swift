//
//  File.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//


import Foundation

// MARK: - Welcome
struct Product: Codable {
    let status: String
    let isError: Bool
    let data: [DatumProdct]
}

// MARK: - Datum
struct DatumProdct: Codable {
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
