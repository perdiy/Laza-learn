//
//  WelcomeViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import Foundation
class WelcomeViewModel {
    
    var loginCompletion: ((_ success: Bool) -> Void)?
    
    func signUp(username: String, password: String) {
        guard !username.isEmpty, !password.isEmpty else {
            loginCompletion?(false)
            return
        }
        
        let postData: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        let url = URL(string: "https://lazaapp.shop/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            do {
                                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let dataDict = jsonResponse?["data"] as? [String: Any],
                                   let accessToken = dataDict["access_token"] as? String {
                                    
                                    // Save token to UserDefaults
                                    UserDefaults.standard.set(accessToken, forKey: "userToken")
                                    UserDefaults.standard.synchronize()
                                    
                                    print("User Token: \(accessToken)")
                                    self.loginCompletion?(true)
                                } else {
                                    self.loginCompletion?(false)
                                    print("Token not found in response.")
                                }
                            } catch {
                                self.loginCompletion?(false)
                                print("Error parsing JSON.")
                            }
                        }
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    self.loginCompletion?(false)
                                    print("Error: \(errorMessage)")
                                }
                            } catch {
                                self.loginCompletion?(false)
                                print("An error occurred.")
                            }
                        }
                    }
                } else {
                    self.loginCompletion?(false)
                    print("An error occurred.")
                }
            }
            task.resume()
        } catch {
            self.loginCompletion?(false)
            print("An error occurred.")
        }
    }
}
