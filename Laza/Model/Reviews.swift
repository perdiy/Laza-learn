//
//  Reviews.swift
//  Laza
//
//  Created by Perdi Yansyah on 17/08/23.
//

import Foundation
struct ReviewResponse: Codable {
    let status: String
    let isError: Bool
    let data: ReviewData
}

struct ReviewData: Codable {
    let ratingAverage: Double
    let total: Int
    let reviews: [Review]
    
    enum CodingKeys: String, CodingKey {
        case ratingAverage = "rating_avrg"
        case total, reviews
    }
}


struct Review: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let fullName: String
    let imageUrl: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case fullName = "full_name"
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
