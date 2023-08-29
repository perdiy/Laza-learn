//
//  ReviewsModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 17/08/23.
//

import Foundation

class ReviewViewModel {
    var reviews: [Review] = []
    var totalReviews: Int = 0
    
    func fetchReviews(productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "https://lazaapp.shop/products/\(productId)/reviews"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let reviewResponse = try decoder.decode(ReviewResponse.self, from: data)
                        self.reviews = reviewResponse.data.reviews
                        self.totalReviews = reviewResponse.data.total
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
