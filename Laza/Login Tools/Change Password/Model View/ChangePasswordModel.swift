//
//  ChangePasswordModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/09/23.
//

import Foundation
class ChangePasswordModel  {
    
    var alertChangePassword: ((String) -> Void)?
    
    func getPass(oldPassword: String, newPassword:String, confirmNewPassword:String,
                      completion: @escaping (Result<Data?, Error>) -> Void)
   { 
       guard let url = URL(string: Endpoints.Gets.chnagePassword.url)  else {
           completion(.failure(ErrorInfo.Error))
           return
       } 
       
       guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
       
       var request = URLRequest(url: url)
       request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
       request.httpMethod = "PUT"
       request.httpBody = ApiService.getHttpBodyRaw(param: [
           "old_password": oldPassword,
           "new_password" : newPassword,
           "re_password" : confirmNewPassword
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
                  let description = jsonResponse["description"] as? String{
                   
                   DispatchQueue.main.async {
                       self.alertChangePassword?(description)
                   }
               }
               completion(.failure(ErrorInfo.Error))
            }
           // Success
           if let data = data,
              let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let message = jsonResponse["data"] as? [String: String],
              let successMessage = message["message"] {
               DispatchQueue.main.async {
                   self.alertChangePassword?(successMessage)
               }
           }
           completion(.success(data))
       }.resume()
   }
}
