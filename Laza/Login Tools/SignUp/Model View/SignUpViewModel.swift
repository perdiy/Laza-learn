//
//  SignUpViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 14/08/23.
//

import Foundation
import UIKit

class SignUpViewModel {
    
    var signUpCompletion: ((_ success: Bool, _ message: String) -> Void)?
    
    func signUp(username: String, email: String, password: String, confirmPassword: String) {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            signUpCompletion?(false, "Please fill in all fields.")
            return
        }
        
        guard password == confirmPassword else {
            signUpCompletion?(false, "Passwords do not match.")
            return
        }
        
        let postData: [String: Any] = [
            "full_name": username,
            "username": username,
            "email": email,
            "password": password
        ]
        
        let url = URL(string: Endpoints.Gets.register.url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        self.signUpCompletion?(true, "Registration successful!")
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    self.signUpCompletion?(false, errorMessage)
                                } else {
                                    self.signUpCompletion?(false, "An error occurred.")
                                }
                            } catch {
                                self.signUpCompletion?(false, "An error occurred.")
                            }
                        }
                    }
                } else {
                    self.signUpCompletion?(false, "An error occurred.")
                }
            }
            task.resume()
        } catch {
            signUpCompletion?(false, "An error occurred.")
        }
    }
}
