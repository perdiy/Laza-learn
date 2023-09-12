//
//  WelcomeViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import Foundation

// login model
class WelcomeViewModel {
    
    // Closure untuk menangani pesan kesalahan
    var apiAlertLogin: ((String, String) -> Void)?
    var apiAlertProfile : ((String) -> Void)?
    
    // Fungsi untuk melakukan login dan mendapatkan data
    func getDataLogin(username: String,
                      password: String,
                      completion: @escaping (Result<Data?, Error>) -> Void) {
        
        // Membuat URL untuk permintaan login
        guard let url = URL(string: Endpoints.Gets.login.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "username": username,
            "password": password
        ])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Jika terjadi error, kirim error melalui completion handler
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            self.apiAlertLogin?(status, description)
                        }
                    }
                    completion(.failure(ErrorInfo.Error))
                } else {
                    if let data = data,
                       let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                       loginResponse.status == "OK",
                       !loginResponse.isError {
                        // Menyimpan access token dan refresh token ke Keychain
                        KeychainManager.shared.saveAccessToken(token: loginResponse.data.access_token)
                        KeychainManager.shared.saveRefreshToken(token: loginResponse.data.refresh_token)
                        print("Access Token: \(loginResponse.data.access_token)")
                        print("refresh Token: \(loginResponse.data.refresh_token)")
                        completion(.success(data))
                    } else {
                        completion(.failure(ErrorInfo.Error))
                    }
                }
            }
        }.resume()
    }
    
    // Fungsi untuk mendapatkan data profil pengguna
    func getUserProfile(completion: @escaping (Result<DataUseProfile?, Error>) -> Void) {
        print("ini prfile")
        guard let url = URL(string: Endpoints.Gets.profile.url) else {return}
        // Mendapatkan access token dari Keychain
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(ErrorInfo.Error))
                
                return
            }
            do {
                let userProfile = try JSONDecoder().decode(profileUser.self, from: data)
                completion(.success(userProfile.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
