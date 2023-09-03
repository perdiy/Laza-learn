////
////  ChangePasswordModel.swift
////  Laza
////
////  Created by Perdi Yansyah on 03/09/23.
////
//
//import Foundation
//
//class ChangePasswordViewModel {
//    
//    var apiAlertChangePassword: ((String) -> Void)?
//    
//    func changePassword(
//        oldPassword: String,
//        newPassword: String,
//        confirmPassword: String,
//        token: String,
//        completion: @escaping (Result<String, Error>) -> Void
//    ) {
//        // Create the URL for the change password endpoint
//        guard let url = URL(string: "https://lazaapp.shop/user/change-password") else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//        
//        // Prepare the request
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
//        
//        let parameters: [String: Any] = [
//            "old_password": oldPassword,
//            "new_password": newPassword,
//            "re_password": confirmPassword
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        // Send the request
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(NetworkError.invalidResponse))
//                return
//            }
//            
//            // Handle the response data
//            if let data = data {
//                do {
//                    let changeResponse = try JSONDecoder().decode(ChangePassword.self, from: data)
//                    if changeResponse.status == "OK" && !changeResponse.isError {
//                        // Password changed successfully
//                        completion(.success(changeResponse.data.message))
//                    } else {
//                        // Password change failed
//                        if let description = changeResponse.data.message {
//                            completion(.failure(NetworkError.custom(description)))
//                        } else {
//                            completion(.failure(NetworkError.unknown))
//                        }
//                    }
//                } catch {
//                    completion(.failure(error))
//                }
//            } else {
//                completion(.failure(NetworkError.unknown))
//            }
//            
//        }.resume()
//    }
//}
//
