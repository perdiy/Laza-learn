//
//  KeychainManager.swift
//  Laza
//
//  Created by Perdi Yansyah on 17/08/23.
//

import Foundation
import KeychainAccess

class KeychainManager {
    static let shared = KeychainManager()
    
    private let keychain = Keychain(service: "MS.Laza")
    
    func saveToken(_ token: String) {
        
        do {
            try keychain.set(token, key: "userToken")
        } catch {
            print("Error saving token to Keychain: \(error.localizedDescription)")
        }
    }
    
    func getToken() -> String? {
        do {
            return try keychain.get("userToken")
        } catch {
            print("Error retrieving token from Keychain: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteToken() {
        do {
            try keychain.remove("userToken")
        } catch {
            print("Error deleting token from Keychain: \(error.localizedDescription)")
        }
    }
}

