//
//  Brand.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//

import Foundation

// MARK: - Welcome
struct Brand: Codable {
    let status: String
    let isError: Bool
    let description: [Description]
}

// MARK: - Description
struct Description: Codable {
    let id: Int
    let name, logoURL: String
    let deletedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoURL = "logo_url"
        case deletedAt = "deleted_at"
    }
}


class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
