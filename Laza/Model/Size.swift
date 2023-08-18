//
//  Size.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//


import Foundation
 
struct Size: Codable {
    let status: String
    let isError: Bool
    let data: [DatumSize]
}

struct DatumSize: Codable {
    let id: Int
    let size: String
}

