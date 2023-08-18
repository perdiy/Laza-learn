//
//  MyProfileModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
// 

import Foundation

protocol MyProfileViewModelDelegate: AnyObject {
    func updateUserProfile(_ userData: DataClass)
}

class MyProfileViewModel {
    
    weak var delegate: MyProfileViewModelDelegate?
    
    func loadUserProfile() {
        if let userToken = UserDefaults.standard.string(forKey: "userToken") {
            let url = URL(string: "https://lazaapp.shop/user/profile")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let userModel = try JSONDecoder().decode(LoginToken.self, from: data)
                        self.delegate?.updateUserProfile(userModel.data)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
            task.resume()
        } else {
            print("User Token not found in UserDefaults.")
        }
    }
}
