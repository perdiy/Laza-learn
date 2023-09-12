//
//  NewPassViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 15/08/23.
//

import Foundation
import UIKit

// New password send new password
class NewPasswordViewModel {
    
    var resetPasswordCompletion: ((_ success: Bool, _ message: String) -> Void)?
    
    func resetPassword(email: String, code: String, newPassword: String, confirmPassword: String) {
        if newPassword != confirmPassword {
            resetPasswordCompletion?(false, "Passwords do not match.")
            return
        }
        
        let url = URL(string: "https://lazaapp.shop/auth/recover/password?email=\(email)&code=\(code)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData: [String: Any] = [
            "new_password": newPassword,
            "re_password": confirmPassword
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.resetPasswordCompletion?(true, "Password reset successful.")
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    self.resetPasswordCompletion?(false, errorMessage)
                                } else {
                                    self.resetPasswordCompletion?(false, "An error occurred.")
                                }
                            } catch {
                                self.resetPasswordCompletion?(false, "An error occurred.")
                            }
                        }
                    }
                } else {
                    self.resetPasswordCompletion?(false, "An error occurred.")
                }
            }
            task.resume()
        } catch {
            self.resetPasswordCompletion?(false, "An error occurred.")
        }
    }
}
