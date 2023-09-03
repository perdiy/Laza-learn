//
//  RefreshToken.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/09/23.
//

import Foundation

class ApiRefreshToken {
    
    func apiRefreshToken(completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let refreshToken = KeychainManager.shared.getRefreshToken() else {
            print("kosong")
            return }
        
        guard let url = URL(string: "") else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "X-Auth-Refresh")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            // bad
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                print("error \(statusCode)")
                completion(.failure(ErrorInfo.Error))
                return
            }
            // yeay
            if let data = data,
               let refreshResponse = try? JSONDecoder().decode(refreshTokenResponse.self, from: data),
               refreshResponse.status == "OK"{
                
                KeychainManager.shared.saveAccessToken(token: refreshResponse.data.access_token)
                KeychainManager.shared.saveRefreshToken(token: refreshResponse.data.refresh_token)
                print("Access Token Terbaru: \(refreshResponse.data.access_token)") // Menampilkan access token
                print("refresh Token Terbaru: \(refreshResponse.data.refresh_token)")
                completion(.success(data))
            } else {
                completion(.failure(ErrorInfo.Error))
            }
        }.resume()
    }
}
