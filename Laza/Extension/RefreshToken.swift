//
//  RefreshToken.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/09/23.
//

import Foundation
import JWTDecode

class ApiCallRefreshToken {
    
    // Mengambil access token dan refresh token dari Keychain
    let token = KeychainManager.shared.getAccessToken()
    let refToken = KeychainManager.shared.getRefreshToken()
    
    // Fungsi untuk melakukan refresh token secara asynchronous
    static func refreshToken(refreshTokenKey: String) async -> Bool {
        // Membuat URL untuk permintaan refresh token
        guard let url = URL(string: Endpoints.Gets.refreshToken.url) else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Menambahkan access token ke header permintaan
        request.setValue("Bearer \(refreshTokenKey)", forHTTPHeaderField: "X-Auth-Refresh")
        do {
            // Mengirim permintaan untuk refresh token
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return false }
            if httpResponse.statusCode != 200 {
                throw "Error: \(httpResponse.statusCode)" as! LocalizedError
            }
            // Menyimpan access token dan refresh token baru ke Keychain
            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            if let data = result?["data"] as? [String: Any],
               let accessToken = data["access_token"] as? String,
               let refreshToken = data["refresh_token"] as? String
            {
                KeychainManager.shared.saveAccessToken(token: accessToken)
                KeychainManager.shared.saveRefreshToken(token: refreshToken)
                print("Access Token Terbaru: \(accessToken)") // Menampilkan access token
                print("refresh Token Terbaru: \(refreshToken)")
            } else {
                throw APIServiceError.accessTokenNotFound
            }
            return true
        } catch {
            print("Refresh token error: ", error.localizedDescription)
            return false
        }
    }
    
    // Fungsi untuk memeriksa dan melakukan refresh token jika diperlukan
    func refreshTokenIfNeeded(completion: @escaping () -> Void, onError: ((String) -> Void)?) {
        guard let refreshToken = KeychainManager.shared.getRefreshToken() else {
            print("kosong")
            return
        }
        // Cek apakah token expired
        guard let jwt = try? decode(jwt: token!) else { return }
        if !jwt.expired {
            completion()
            return
        }
        // Memeriksa dan melakukan refresh token secara asynchronous
        Task {
            let isSuccess = await ApiCallRefreshToken.refreshToken(refreshTokenKey: refreshToken)
            isSuccess ? completion() : onError?("Error refresh token")
        }
    }
    
}

// Enum untuk kesalahan
enum APIServiceError: Error {
    case accessTokenNotFound
    case invalidURL
    
}
