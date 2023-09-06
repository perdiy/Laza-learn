//
//  SideMenuModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23. 
//


import Foundation

class UserProfileViewModel {
    // Properti untuk menyimpan nama pengguna dan URL gambar profil
    var username: String = ""
    var imageUrl: String?

    // Fungsi untuk memuat profil pengguna dari server
    func loadUserProfile(completion: @escaping (Error?) -> Void) {
        // Memeriksa apakah token pengguna tersimpan di Keychain
        if let userToken = KeychainManager.shared.getAccessToken() {
            let url = URL(string: "https://lazaapp.shop/user/profile")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")

            // Mengirim permintaan ke server
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        // Mendekode data JSON yang diterima ke dalam model LoginToken
                        let userModel = try JSONDecoder().decode(LoginToken.self, from: data)
                        self.username = userModel.data.username
                        self.imageUrl = userModel.data.imageUrl
                        completion(nil)
                    } catch {
                        completion(error)
                    }
                } else if let error = error {
                    completion(error) 
                }
            }
            task.resume()
        } else {
            // Jika token pengguna tidak ditemukan di Keychain, kirimkan error
            let error = NSError(domain: "User Token not found in Keychain.", code: 0, userInfo: nil)
            completion(error)
        }
    }

    // Fungsi untuk logout pengguna
    func logout(completion: @escaping (Error?) -> Void) {
        // Hapus token pengguna dari Keychain
        KeychainManager.shared.deleteAccessToken()

        completion(nil) // Panggilan selesai tanpa error
    }
}
