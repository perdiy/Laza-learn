//
//  MyProfileModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import Foundation

// Protocol untuk delegate yang akan menerima pembaruan profil pengguna
protocol MyProfileViewModelDelegate: AnyObject {
    func updateUserProfile(_ userData: DataClass)
}

class MyProfileViewModel {
    
    weak var delegate: MyProfileViewModelDelegate? // Delegate yang akan menerima pembaruan profil
    
    // Method untuk memuat profil pengguna
    func loadUserProfile() {
        if let userToken = KeychainManager.shared.getAccessToken() {
            let url = URL(string: Endpoints.Gets.profile.url)! // URL untuk mengambil profil pengguna
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token") // Menambahkan token pengguna ke header
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        // Mendekode respons JSON ke dalam model data
                        let userModel = try JSONDecoder().decode(LoginToken.self, from: data)
                        
                        // Memanggil delegate untuk memberi tahu bahwa data profil telah dimuat
                        self.delegate?.updateUserProfile(userModel.data)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
            task.resume()
        } else {
            print("User Token not found in Keychain.") // Jika token pengguna tidak ditemukan
        }
    }
}
