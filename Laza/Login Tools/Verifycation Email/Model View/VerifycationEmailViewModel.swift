//
//  VerifycationEmailViewModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/09/23.
//

import Foundation

// send email verifycation
class VerifyEmailViewModel{
    
    // Deklarasi closure yang dapat digunakan untuk mengirim hasil verifikasi email
    var apiVerifyEmail : ((String) -> Void)?
    
    func sendVeifyEmail(email: String,
                        completion: @escaping (Result<Data?, Error>) -> Void) {
        
        // Membuat URL endpoint verifikasi email
        guard let url = URL(string: Endpoints.Gets.verifyEmail.url) else {
            // Jika URL tidak valid, panggil closure completion dengan hasil failure
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        // Membuat permintaan HTTP POST dengan data email
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "email": email
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
                
                // Jika server memberikan respons dengan kode status yang tidak sama dengan 200 (OK)
                // maka ini dianggap sebagai kesalahan
                print("Response Status Code: \(statusCode)")
                if let data = data,
                   let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let data = jsonResponse["data"] as? [String: String],
                   let description = data["description"] {
                    
                    // Jika terdapat deskripsi kesalahan dalam respons JSON, panggil closure apiVerifyEmail untuk memberi tahu pengguna
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
