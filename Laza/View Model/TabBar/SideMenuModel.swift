//
//  SideMenuModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23. 
//


import Foundation

class UserProfileViewModel {
    var username: String = ""
    var imageUrl: String? 
    
    func loadUserProfile(completion: @escaping (Error?) -> Void) {
        if let userToken = KeychainManager.shared.getAccessToken() {
            let url = URL(string: "https://lazaapp.shop/user/profile")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let userModel = try JSONDecoder().decode(LoginToken.self, from: data)
                        self.username = userModel.data.username
                        self.imageUrl = userModel.data.imageUrl
                        completion(nil)
                    } catch {
                        completion(error)
                    }
                } else if let error = error {
                    completion(error)
                }
            }
            task.resume()
        } else {
            let error = NSError(domain: "User Token not found in Keychain.", code: 0, userInfo: nil)
            completion(error)
        }
    }
    
    func logout(completion: @escaping (Error?) -> Void) {
        KeychainManager.shared.deleteAccessToken()
    
        completion(nil)
    }
}
