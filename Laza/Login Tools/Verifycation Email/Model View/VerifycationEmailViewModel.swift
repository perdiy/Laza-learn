//
//  VerifycationEmailViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/09/23.
//

import Foundation

class VerifyEmailViewModel{
    var apiVerifyEmail : ((String) -> Void)?
    
    func sendVeifyEmail(email: String,
                        completion: @escaping (Result<Data?, Error>) -> Void) {
        
        guard let url = URL(string: Endpoints.Gets.verifyEmail.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "email": email
        ])
         
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            if let statusCode = httpResponse?.statusCode, statusCode != 200 {
                // Error
                print("Response Status Code: \(statusCode)")
                if let data = data,
                   let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let data = jsonResponse["data"] as? [String: String],
                   let description = data["description"] {
                    
                    DispatchQueue.main.async {
                        self.apiVerifyEmail?(description)
                    }
                }
                completion(.failure(ErrorInfo.Error))
            }
            completion(.success(data))
        }.resume()
    }
}
