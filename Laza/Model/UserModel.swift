//
//  UserModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//

import Foundation

struct WelcomeElement: Codable {
    let address: Address
    let id: Int
    let email, username, password: String
    let name: Name
    let phone: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case address, id, email, username, password, name, phone
        case v = "__v"
    }
}

struct Address: Codable {
    let geolocation: Geolocation
    let city, street: String
    let number: Int
    let zipcode: String
}

struct Geolocation: Codable {
    let lat, long: String
}

struct Name: Codable {
    let firstname, lastname: String
}

