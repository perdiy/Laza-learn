//
//  EditProfileViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 02/09/23.
//

import Foundation
import UIKit

class ProfileService {
    static let shared = ProfileService() // Singleton instance dari layanan ProfileService
    
    private init() {} // Inisialisasi privat untuk memastikan hanya satu instance yang dapat dibuat
    
    // Method untuk mengupdate profil pengguna dengan parameter yang diperlukan
    func updateProfile(fullName: String, username: String, email: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let userToken = KeychainManager.shared.getAccessToken() else {
            completion(false) // Jika token pengguna tidak tersedia, panggil completion handler dengan false
            return
        }
        
        let apiUrl = URL(string: "https://lazaapp.shop/user/update")! // URL API untuk mengupdate profil
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "PUT" // Menggunakan metode HTTP PUT
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token") // Menambahkan token pengguna ke header
        
        // Membuat boundary untuk data yang akan dikirim sebagai multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data() // Membuat body untuk permintaan HTTP
        
        // Data yang akan diupdate (full_name, username, email)
        let updateData: [String: Any] = [
            "full_name": fullName,
            "username": username,
            "email": email
        ]
        
        // Menambahkan data yang akan diupdate ke body permintaan
        for (key, value) in updateData {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // Mengambil data gambar profil dan mengirimkannya sebagai bagian dari body
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"profile_image.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n") // Menambahkan boundary penutup
        request.httpBody = body
        
        // Mengirim permintaan ke server
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating profile: \(error)") // Jika terjadi error, mencetak pesan error
                completion(false) // Panggil completion handler dengan false
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Profile updated successfully!") // Jika status kode 200, profil berhasil diupdate
                    completion(true) // Panggil completion handler dengan true
                } else {
                    print("Error updating profile: Status code \(httpResponse.statusCode)") // Jika status kode bukan 200, mencetak pesan error
                    completion(false) // Panggil completion handler dengan false
                }
            }
        }.resume()
    }
}
