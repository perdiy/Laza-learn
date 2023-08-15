////
////  SignUpViewModel.swift
////  Laza
////
////  Created by Perdi Yansyah on 14/08/23.
////
//
//import Foundation
//
//
//class SignUpViewModel {
//    var userName: String = ""
//    var email: String = ""
//    var confirmPassword: String = ""
//    var password: String = ""
//
//    func validateTextFields() -> Bool {
//        return !userName.isEmpty && !email.isEmpty && !confirmPassword.isEmpty && !password.isEmpty
//    }
//
//    func signUp(completion: @escaping (Bool) -> Void) {
//        guard password == confirmPassword else {
//            completion(false)
//            return
//        }
//
//        let parameters: [String: Any] = [
//            "full_name": userName,
//            "username": userName,
//            "email": email,
//            "password": password
//        ]
//
//        guard let url = URL(string: "https://lazaapp.shop/register") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = SignUpViewModel.getHttpBodyRaw(param: parameters)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//
//            if let data = data {
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    if let status = jsonResponse?["status"] as? String {
//                        if status == "success" {
//                            completion(true)
//                        } else {
//                            completion(false)
//                        }
//                    }
//                } catch {
//                    print("Error parsing JSON response: \(error.localizedDescription)")
//                    completion(false)
//                }
//            }
//        }
//
//        task.resume()
//    }
//
//    static func getHttpBodyRaw(param: [String: Any]) -> Data? {
//        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
//        return jsonData
//    }
//}
//
