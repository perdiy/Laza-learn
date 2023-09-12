//
//  SignUpViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//

import Foundation
import UIKit

// sign Up
class SignUpViewModel {
    
    // Closure untuk memberikan pemberitahuan atau pesan hasil pendaftaran
    var signUpCompletion: ((_ success: Bool, _ message: String) -> Void)?
    
    // Fungsi untuk melakukan pendaftaran pengguna
    func signUp(username: String, email: String, password: String, confirmPassword: String) {
        // Memeriksa apakah semua field isian telah diisi
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            signUpCompletion?(false, "Please fill in all fields.")
            return
        }
        
        // Memeriksa apakah kata sandi dan konfirmasi kata sandi cocok
        guard password == confirmPassword else {
            signUpCompletion?(false, "Passwords do not match.")
            return
        }
        
        // Membuat data yang akan dikirimkan ke server dalam format JSON
        let postData: [String: Any] = [
            "full_name": username,
            "username": username,
            "email": email,
            "password": password
        ]
        
        // Membuat URL endpoint pendaftaran
        let url = URL(string: Endpoints.Gets.register.url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
            
            // Melakukan permintaan jaringan dengan URLSession
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        // Jika pendaftaran berhasil (kode status 201), panggil closure signUpCompletion dengan hasil sukses
                        self.signUpCompletion?(true, "Registration successful!")
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    self.signUpCompletion?(false, errorMessage)
                                } else {
                                    // Jika tidak ada pesan kesalahan yang diuraikan, panggil closure signUpCompletion dengan pesan kesalahan umum
                                    self.signUpCompletion?(false, "An error occurred.")
                                }
                            } catch {
                                // Jika terjadi kesalahan dalam menguraikan JSON, panggil closure signUpCompletion dengan pesan kesalahan umum
                                self.signUpCompletion?(false, "An error occurred.")
                            }
                        }
                    }
                } else {
                    // Jika tidak ada respons HTTP, panggil closure signUpCompletion dengan pesan kesalahan umum
                    self.signUpCompletion?(false, "An error occurred.")
                }
            }
            task.resume()
        } catch {
            // Jika terjadi kesalahan dalam membuat data JSON, panggil closure signUpCompletion dengan pesan kesalahan umum
            signUpCompletion?(false, "An error occurred.")
        }
    }
}
