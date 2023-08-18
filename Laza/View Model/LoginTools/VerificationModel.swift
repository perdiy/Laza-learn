//
//  VerificationModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import Foundation
import UIKit
import DPOTPView 

class VerificationCodeViewModel {
    
    var verifyCodeCompletion: ((_ success: Bool, _ message: String) -> Void)?
    
    func verifyCode(email: String, code: String) {
        let url = URL(string: "https://lazaapp.shop/auth/recover/code")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData: [String: Any] = [
            "email": email,
            "code": code
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 202 {
                        self.verifyCodeCompletion?(true, "Verification successful.")
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    self.verifyCodeCompletion?(false, errorMessage)
                                } else {
                                    self.verifyCodeCompletion?(false, "An error occurred.")
                                }
                            } catch {
                                self.verifyCodeCompletion?(false, "An error occurred.")
                            }
                        }
                    }
                } else {
                    self.verifyCodeCompletion?(false, "An error occurred.")
                }
            }
            task.resume()
        } catch {
            self.verifyCodeCompletion?(false, "An error occurred.")
        }
    }
}
