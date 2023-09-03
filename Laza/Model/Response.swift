//
//  Response.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/09/23.
//

import Foundation

// MARK: - Welcome
struct ChangePassword: Codable {
    let status: String
    let isError: Bool
    let data: Change
}

// MARK: - DataClass
struct Change: Codable {
    let message: String
}

// MARK: - Welcome
struct StatusChange: Codable {
    let status: String
    let isError: Bool
    let description: String
}


struct UpdateProfileResponse: Codable {
    let status: String
    let isError: Bool
    let description: String?
}
