//
//  AddReviewsModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 20/08/23.
//

import Foundation

class AddReviewViewModel {
    let initialRating: Float = 0.0
    
    func uploadReview(productId: Int, token: String, rating: Float, comment: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Prepare and perform the API request
        guard let url = URL(string: "https://lazaapp.shop/products/\(productId)/reviews") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the review data
        let ratingValue = round(rating * 2) / 2
        let reviewData: [String: Any] = [
            "rating": ratingValue,
            "comment": comment
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reviewData, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        // Perform the API request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    // Review submitted successfully
                    completion(.success(()))
                } else {
                    // Handle other status codes if needed
                    completion(.failure(NetworkError.httpError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case httpError(Int)
}

