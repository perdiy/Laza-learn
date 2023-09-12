//
//  ChangePasswordModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/09/23.
//

import Foundation

// ubah password pemanggila API
class ChangePasswordModel  {
    
    // Closure untuk memberikan pemberitahuan atau pesan kesalahan/keberhasilan
    var alertChangePassword: ((String) -> Void)?
    
    // Fungsi untuk mengganti kata sandi
    func getPass(oldPassword: String, newPassword:String, confirmNewPassword:String,
                 completion: @escaping (Result<Data?, Error>) -> Void)
    {
        // Membuat URL untuk endpoint pergantian kata sandi
        guard let url = URL(string: Endpoints.Gets.chnagePassword.url)  else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        
        // Membuat permintaan HTTP PUT dengan token akses dan data kata sandi lama dan baru
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "PUT"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "old_password": oldPassword,
            "new_password" : newPassword,
            "re_password" : confirmNewPassword
        ])
        
        // Melakukan permintaan jaringan dengan URLSession
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            let httpResponse = response as? HTTPURLResponse
            if let statusCode = httpResponse?.statusCode, statusCode != 200 {
                // Jika server memberikan respons dengan kode status yang tidak sama dengan 200 (OK),
                // maka ini dianggap sebagai kesalahan
                print("Response Status Code: \(statusCode)")
                if let data = data,
                   let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let description = jsonResponse["description"] as? String{
                    
                    // Panggil closure alertChangePassword untuk memberi tahu pengguna tentang kesalahan
                    DispatchQueue.main.async {
                        self.alertChangePassword?(description)
                    }
                }
                completion(.failure(ErrorInfo.Error))
            }
            
            // Jika permintaan berhasil, ambil pesan keberhasilan dari respons
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
