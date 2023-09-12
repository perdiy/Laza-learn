//
//  Brand all View Model.swift
//  Laza
//
//  Created by Perdi Yansyah on 11/09/23.
//

import Foundation

class ProductByBrandViewModel {
    
    var products: [prodByIdBrandEntry] = []
    var brandName: String = ""
    var imgUrl: String = ""
    
    // Closure untuk memberi tahu tampilan bahwa data telah diambil
    var dataLoaded: (() -> Void)?
    
    func loadDataFromAPI() {
        let apiURLString = "https://lazaapp.shop/products/brand?name=\(brandName)"
        
        if let apiURL = URL(string: apiURLString) {
            URLSession.shared.dataTask(with: apiURL) { [weak self] data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let productsResponse = try decoder.decode(prudctByIdBrandResponse.self, from: data)
                        
                        // Menyimpan data produk
                        self?.products = productsResponse.data
                        
                        // Memberitahu tampilan bahwa data telah diambil
                        self?.dataLoaded?()
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}
