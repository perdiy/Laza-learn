//
//  DetailModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 17/08/23.
// 

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func updateSizes(_ sizes: [SizeDetailProd])
}

class DetailViewModel {
    var apiAlertDetailProduct: ((String, String) -> Void)?
    var apiAlertMessage: ((String) -> Void)?
    weak var delegate: DetailViewModelDelegate?
    
    func fetchSizes(for productId: Int) {
        getDataDetailProduct(id: productId) { [weak self] productDetail in
            guard let sizes = productDetail?.data.size else {
                print("Sizes not found")
                return
            }
            self?.delegate?.updateSizes(sizes)
        }
    }
    
    func getDataDetailProduct(id: Int, completion: @escaping (DetailProduct?) -> ()) {
        let urlString = "https://lazaapp.shop/products/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let productList = try JSONDecoder().decode(DetailProduct.self, from: data)
                completion(productList)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func addProducInCart(ProductId: Int, SizeId: Int, userToken: String, completion: @escaping (Result<CartProduct, Error>) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/carts?ProductId=\(ProductId)&SizeId=\(SizeId)") else {
            print("Invalid url.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 201 {
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            self.apiAlertDetailProduct?(status, data)
                        }
                        print("INI ERROR\(jsonResponse)")
                    }
                } else {
                    if let data = data {
                        do {
                            let cartProduct = try JSONDecoder().decode(CartProduct.self, from: data)
                            completion(.success(cartProduct))
                        } catch {
                            print("JSON Decoding Error: \(error)")
                            completion(.failure(error))
                        }
                    }
                }
            }

        }.resume()
    }

    
    func fetchWishlist(token: String, completion: @escaping ([ProductWishlist]) -> Void) {
        guard let apiUrl = URL(string: "https://lazaapp.shop/wishlists") else {
            completion([])
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching wishlist data: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            do {
                let wishlistResponse = try JSONDecoder().decode(Wishlist.self, from: data)
                let wishlistItems = wishlistResponse.data.products
                completion(wishlistItems)
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
    // MARK: - Func PUT Wihslist using API
    func putWishlistUser(productId: Int, userToken: String, completion: @escaping (Result<UpdateWishlist, Error>) -> Void) {
        
        guard let components = URLComponents(string: "https://lazaapp.shop/wishlists?ProductId=\(productId)") else {
            print("Invalid URL.")
            return
        }
        
        guard let url = components.url else {
            print("Invalid URL components.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            self.apiAlertDetailProduct?(status, data)
                        }
                        print("Update Wishlist\(jsonResponse)")
                    }
                    completion(.failure(ErrorInfo.Error))
                } else {
                    if let data = data {
                        if let putWishlistResponse = try? JSONDecoder().decode(UpdateWishlist.self, from: data),
                           putWishlistResponse.status == "OK",
                           !putWishlistResponse.isError {
                            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let responseData = jsonResponse["data"] as? String,
                               let status = jsonResponse["status"] as? String {
                                DispatchQueue.main.async {
                                    self.apiAlertDetailProduct?(status, responseData)
                                }
                            }
                            completion(.success(putWishlistResponse))
                        } else {
                            completion(.failure(ErrorInfo.Error))
                        }
                    }
                    
                }
            }
        }.resume()
        
    }
    
    
}
