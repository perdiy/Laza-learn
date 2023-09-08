//
//  AddressModelView.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//


import Foundation

class ListAddressViewModel {
    var addresses: [DataAllAddress] = []
    
    func fetchAddresses(completion: @escaping (Error?) -> Void) {
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            completion(nil)
            return
        }
        
        let urlString = "https://lazaapp.shop/address"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        
        print("Fetching addresses...")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching addresses:", error)
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let addressResponse = try JSONDecoder().decode(AllAddress.self, from: data)
                if let addresses = addressResponse.data {
                    self?.addresses = addresses
                    print("Addresses fetched")
                    completion(nil)
                }
            } catch let error {
                print("Error decoding data:", error)
                completion(error)
            }
        }.resume()
    }
    
    func deleteAddress(at indexPath: IndexPath, completion: @escaping (Error?) -> Void) {
        guard indexPath.row < addresses.count else {
            print("Invalid index")
            return
        }
        
        let address = addresses[indexPath.row]
        let urlString = "https://lazaapp.shop/address/\(address.id)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        
        print("Deleting address...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting address:", error)
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
    }
}
