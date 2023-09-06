//
//  CartModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//

import Foundation

class CartViewModel {
    func fetchAddresses(completion: @escaping ([DataAllAddress]?) -> Void) {
        
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            completion(nil)
            return
        }
        
        let urlString = "https://lazaapp.shop/address"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching addresses:", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let addressResponse = try JSONDecoder().decode(AllAddress.self, from: data)
                if let addresses = addressResponse.data {
                    completion(addresses)
                } else {
                    completion(nil)
                }
            } catch let error {
                print("Error decoding data:", error)
                completion(nil)
            }
        }.resume()
    }
    
    func getProducInCart(accessTokenKey: String, completion: @escaping (CartProduct) -> Void) {
        guard let url = URL(string: Endpoints.Gets.cartsAll.url) else {
            print("Invalid url.")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let cartProducts = try JSONDecoder().decode(CartProduct.self, from: data)
                
                DispatchQueue.main.async {
                    completion(cartProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                
            }
        }.resume()
        
    }
    
    
    func deleteCartItem(productId: Int, sizedId: Int, completion: @escaping () -> Void) {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("User token not available.")
            return
        }
        
        // Buat URL untuk penghapusan item
        guard let url = URL(string: "https://lazaapp.shop/carts?ProductId=\(productId)&SizeId=\(sizedId)") else {
            print("Invalid URL")
            return
        }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let authorizationHeader = "Bearer \(token)"
        request.setValue(authorizationHeader, forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting item: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("Item deleted successfully")
                    completion()
                } else {
                    print("Error deleting item. Status code: \(response.statusCode)")
                }
            }
        }.resume()
    }
    
    func getSizeAll(completion:@escaping (AllSize) -> ()) {
        guard let url = URL(string: Endpoints.Gets.sizeAll.url) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let sizeList = try JSONDecoder().decode(AllSize.self, from: data)
                DispatchQueue.main.async {
                    completion(sizeList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    func addCartItemQuantity(productId: Int, sizedId: Int, completion: @escaping () -> Void) {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("User token not available.")
            return
        }
        guard let url = URL(string: "https://lazaapp.shop/carts?ProductId=\(productId)&SizeId=\(sizedId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let authorizationHeader = "Bearer \(token)"
        request.setValue(authorizationHeader, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding item to cart: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 201 {
                    print("Item added to cart successfully")
                    completion()
                } else {
                    print("Error adding item to cart. Status code: \(response.statusCode)")
                }
            }
        }.resume()
    }
    
    func decreaseCartItemQuantity(productId: Int, sizedId: Int, completion: @escaping () -> Void) {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("User token not available.")
            return
        }
        
        guard let url = URL(string: "https://lazaapp.shop/carts?ProductId=\(productId)&SizeId=\(sizedId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let authorizationHeader = "Bearer \(token)"
        request.setValue(authorizationHeader, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding item to cart: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("Item added to cart successfully")
                    completion()
                } else {
                    print("Error adding item to cart. Status code: \(response.statusCode)")
                }
            }
        }.resume()
    }
    
}
