//
//  NestedViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import Foundation

class NestedModel {
    static let shared = NestedModel()
    
    private init() {}
    
    func fetchCategories(completion: @escaping (Brand) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/brand") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let brandResponse = try decoder.decode(Brand.self, from: data)
                let brandNames = brandResponse.description.map { $0.name }
//                completion(brandResponse)
                DispatchQueue.main.async {
                    completion(brandResponse)
                }
            } catch {
                print("Error fetching categories: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func fetchProducts(completion: @escaping ([DatumProdct]) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/products") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let productResponse = try decoder.decode(Product.self, from: data)
                DispatchQueue.main.async {
                    completion(productResponse.data)
                }
            } catch {
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
