//
//  NestedViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

//import Foundation
//
//class NestedViewModel {
//    var categories: [String] = []
//    var products: [DatumProdct] = []
//    var filteredProducts: [DatumProdct] = []
//    
//    func fetchCategories(completion: @escaping (Error?) -> Void) {
//        guard let url = URL(string: "https://lazaapp.shop/brand") else {
//            completion(nil)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
//            guard let self = self, let data = data else {
//                completion(error)
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let brandResponse = try decoder.decode(Brand.self, from: data)
//                let brandNames = brandResponse.description.map { $0.name }
//                DispatchQueue.main.async {
//                    self.categories = brandNames
//                    completion(nil)
//                }
//            } catch {
//                completion(error)
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func fetchProducts(completion: @escaping (Error?) -> Void) {
//        guard let url = URL(string: "https://lazaapp.shop/products") else {
//            completion(nil)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
//            guard let self = self, let data = data else {
//                completion(error)
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let productResponse = try decoder.decode(Product.self, from: data)
//                DispatchQueue.main.async {
//                    self.products = productResponse.data
//                    self.filteredProducts = productResponse.data
//                    completion(nil)
//                }
//            } catch {
//                completion(error)
//            }
//        }
//        
//        task.resume()
//    }
//}
//
