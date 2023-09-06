//
//  GetWhistlist.swift
//  Laza
//
//  Created by Perdi Yansyah on 30/08/23.
//

import Foundation

class FavoriteViewModel {
    var wishlistItems: [ProductWishlist] = []
    
    func fetchWishlistItems(token: String, completion: @escaping ([ProductWishlist]) -> Void) {
        guard let apiUrl = URL(string: Endpoints.Gets.wishlistAll.url)else {
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

