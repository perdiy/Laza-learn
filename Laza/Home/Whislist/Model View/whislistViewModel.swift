//
//  whislistViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//

import Foundation

class addProductToWishlist {
    
    func addProductToWishlist(productId: Int) {
        guard let token = KeychainManager.shared.getAccessToken()else {
            print("User token not found in Keychain.")
            return
        }
        
        let urlString = "https://lazaapp.shop/wishlists?ProductId=\(productId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for adding to wishlist.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding product to wishlist: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Product added to wishlist!")
                    DispatchQueue.main.async {
                        //                        self.showAddToWishlistAlert()
                    }
                } else {
                    print("Failed to add product to wishlist. Status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    var wishlistItems: [ProductWishlist] = []
    
    func fetchWishlistItems(completion: @escaping ([ProductWishlist]) -> Void) {
        guard let token = KeychainManager.shared.getAccessToken(),
              let apiUrl = URL(string: "https://lazaapp.shop/wishlists") else {
            completion([])
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
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
}
