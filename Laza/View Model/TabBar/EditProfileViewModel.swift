//
//  EditProfileViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 02/09/23.
//

import Foundation
import UIKit

class ProfileService {
    static let shared = ProfileService()
    
    private init() {}
    
    func updateProfile(fullName: String, username: String, email: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let userToken = KeychainManager.shared.getAccessToken() else {
            completion(false)
            return
        }
        
        let apiUrl = URL(string: "https://lazaapp.shop/user/update")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let updateData: [String: Any] = [
            "full_name": fullName,
            "username": username,
            "email": email
        ]
        
        for (key, value) in updateData {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"profile_image.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating profile: \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Profile updated successfully!")
                    completion(true)
                } else {
                    print("Error updating profile: Status code \(httpResponse.statusCode)")
                    completion(false)
                }
            }
        }.resume()
    }
}

