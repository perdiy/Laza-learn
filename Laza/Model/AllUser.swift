//
//  AllUser.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/09/23.
//

import Foundation

// MARK: - User
typealias UserIndex = [allUser]
struct userIndex : Codable{
    var results: [allUser]!
}

struct allUser : Codable {
//    var full_name : String
    var username : String
    var email : String
    var password : String

}

struct Name : Codable {
    var firstname : String
    var lastname : String
}
