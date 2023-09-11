//
//  Add Address View Model.swift
//  Laza
//
//  Created by Perdi Yansyah on 11/09/23.
//

import Foundation

class AddressViewModel {
    // Fungsi ini digunakan untuk menyimpan alamat baru ke server.
    // Parameter yang diterima mencakup semua informasi yang diperlukan untuk alamat.
    // Hasil akhirnya akan disampaikan melalui completion handler.
    func saveAddress(name: String, phone: String, city: String, country: String, isPrimary: Bool, userToken: String, completion: @escaping (Bool, Error?) -> Void) {
        let apiURLString = "https://lazaapp.shop/address"
        
        guard let apiURL = URL(string: apiURLString) else {
            // Jika URL tidak valid, maka panggilan API akan dibatalkan dan lakukan pemanggilan kembali ke completion handler dengan nilai false dan tanpa error.
            completion(false, nil)
            return
        }
        
        // Membuat objek URLRequest untuk mengirim permintaan ke server.
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Membentuk data JSON yang akan dikirimkan ke server dengan informasi alamat baru.
        let newAddress = [
            "receiver_name": name,
            "phone_number": phone,
            "city": city,
            "country": country,
            "is_primary": isPrimary
        ] as [String: Any]
        
        do {
            // Mengubah data JSON ke format Data yang dapat digunakan untuk mengatur body permintaan HTTP.
            let jsonData = try JSONSerialization.data(withJSONObject: newAddress, options: [])
            request.httpBody = jsonData
        } catch {
            // Handle JSON serialization error
            completion(false, error)
            return
        }
        // Membuat objek URLSession untuk melakukan pemanggilan API.
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            // Handle response and error
            if let error = error {
                completion(false, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    // Jika respon dari server adalah 2xx (berhasil), maka pemanggilan API dianggap berhasil.
                    completion(true, nil)
                } else {
                    // Jika respon dari server adalah di luar kisaran 2xx (gagal), maka pemanggilan API dianggap gagal.
                    completion(false, nil)
                }
            }
        }
        // Mulai eksekusi task untuk melakukan pemanggilan API.
        task.resume()
    }
}

