//
//  CartModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//

import Foundation

class CartViewModel {
    var apiCarts: ((String, String) -> Void)?
    
    // get Product
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
    
    // delete cart
    func deleteCartItem(productId: Int, sizedId: Int, completion: @escaping () -> Void) {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("User token not available.")
            return
        }
        
        // Buat URL untuk penghapusan item
        guard let url = URL(string: Endpoints.Gets.deleteCarts(idProduct: productId, idSize: sizedId).url) else {
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
    
    // get all size
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
    
    
    // order
    func postOrder(product: [DataProduct], address_id: Int, bank: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let url = URL(string: Endpoints.Gets.order.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        guard let accessToken = KeychainManager.shared.getAccessToken() else { return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "POST"
        
        do {
            let checkoutBody = CheckoutBody(products: product, addressId: address_id, bank: bank)
            let encoder = JSONEncoder()
            let json = try encoder.encode(checkoutBody)
            request.httpBody = json
        } catch {
            print("Error checkout JSON")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 201 {
                    print("Checkout Status Respons: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        
                        DispatchQueue.main.async {
                            self.apiCarts?(status, description)
                        }
                    }
                    completion(.failure(ErrorInfo.Error))
                } else {
                    print("Berhasil checkout")
                    completion(.success(data))
                }
            }
        }.resume()
    }
    
}
