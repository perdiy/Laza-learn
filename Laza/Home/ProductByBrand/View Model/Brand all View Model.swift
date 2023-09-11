//
//  Brand all View Model.swift
//  Laza
//
//  Created by Perdi Yansyah on 11/09/23.
//

import Foundation

class BrandProductsViewModel {
    var products: [prodByIdBrandEntry] = []

    func fetchProducts(for brandName: String, imgUrl: String, completion: @escaping () -> Void) {
        let apiURLString = "https://lazaapp.shop/products/brand?name=\(brandName)"

        if let apiURL = URL(string: apiURLString) {
            URLSession.shared.dataTask(with: apiURL) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }

                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let productsResponse = try decoder.decode(prudctByIdBrandResponse.self, from: data)
                        self.products = productsResponse.data
                        DispatchQueue.main.async {
                            completion()
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}
