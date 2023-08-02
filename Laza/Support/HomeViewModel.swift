////
////  HomeViewModel.swift
////  Laza
////
////  Created by Perdi Yansyah on 31/07/23.
////
//
//import Foundation
//
//protocol HomeViewModelDelegate: AnyObject {
//    func didFetchProducts()
//    func didFetchCategories()
//}
//
//class HomeViewModel {
//    weak var delegate: HomeViewModelDelegate?
//    
//    var products: [Product] = [] // Menggunakan Model Product sesuai struktur data
//    var categories: [Category] = [] // Array untuk menyimpan enum Category
//    
//    // Apifetch untuk enum Category
//    func fetchCategoriesFromAPI() {
//        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            if let data = data {
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                    if let categoriesArray = jsonResponse as? [String] {
//                        self.categories = categoriesArray.compactMap { Category(rawValue: $0) }
//                        DispatchQueue.main.async {
//                            self.delegate?.didFetchCategories()
//                        }
//                    }
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }.resume()
//    }
//    
//    // Apifetch untuk data produk
//    func fetchDataFromAPI() {
//        guard let url = URL(string: "https://fakestoreapi.com/products") else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            if let data = data {
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                    if let productsArray = jsonResponse as? [[String: Any]] {
//                        self.products = productsArray.compactMap { Product(dictionary: $0) } // Menggunakan Model Product untuk menginisialisasi array produk
//                        DispatchQueue.main.async {
//                            self.delegate?.didFetchProducts()
//                        }
//                    }
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }.resume()
//    }
//}
