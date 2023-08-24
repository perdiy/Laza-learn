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
    
    func addProducInCart(ProductId: Int, SizeId: Int, userToken: String, completion: @escaping (CartProduct) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/carts?ProductId=\(ProductId)&SizeId=\(SizeId)") else {
            print("Invalid url.")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Response: \(jsonResponse)")
                        
                        if let isError = jsonResponse["isError"] as? Int, isError != 0,
                           let description = jsonResponse["description"] as? String,
                           let status = jsonResponse["status"] as? String {
                            
                            DispatchQueue.main.async {
                                
                            }
                            print(description, status)
                        } else {
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                DispatchQueue.main.async {
                                    
                                    
                                    print("BerhasilResponse: \(jsonResponse)")
                                }
                            } else {
                                print("Added to cart error: Unexpected Response Code")
                            }
                        }
                    }
                } catch {
                    print("JSON Serialization Error: \(error)")
                }
            }
        }.resume()
    }
    
}
