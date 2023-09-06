//
//  ForgotPasswordModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import Foundation
import UIKit

class ForgotPwdViewModel {
    
    var resetPasswordCompletion: ((_ success: Bool, _ message: String) -> Void)?
    
    func resetPassword(email: String) {
        let postData: [String: Any] = ["email": email]
        
        guard let url = URL(string: Endpoints.Gets.forgotPassword.url) else {
            resetPasswordCompletion?(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    self.resetPasswordCompletion?(false, "Gagal melakukan koneksi ke server.")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.resetPasswordCompletion?(true, "Reset password email sent successfully.")
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
                }
            }
            task.resume()
        } catch {
            self.resetPasswordCompletion?(false, "Terjadi kesalahan saat mengirim data.")
        }
    }
}
