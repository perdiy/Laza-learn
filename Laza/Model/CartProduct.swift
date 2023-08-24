//
//  CartProduct.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//

import Foundation

// MARK: - CartProduct
struct CartProduct: Codable {
    let status: String
    let isError: Bool
    let data: DataCart
}

// MARK: - DataCart
struct DataCart: Codable {
    var products: [ProductCart]?
    let orderInfo: OrderInfo

    enum CodingKeys: String, CodingKey {
        case products
        case orderInfo = "order_info"
    }
}

// MARK: - OrderInfo
struct OrderInfo: Codable {
    let subTotal, shippingCost, total: Int

    enum CodingKeys: String, CodingKey {
        case subTotal = "sub_total"
        case shippingCost = "shipping_cost"
        case total
    }
}

// MARK: - Product
struct ProductCart: Codable {
    let id: Int
    let productName: String
    let imageURL: String
    let price: Int
    let brandName: String
    let quantity: Int
    let size: String

    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case imageURL = "image_url"
        case price
        case brandName = "brand_name"
        case quantity, size
    }
}
