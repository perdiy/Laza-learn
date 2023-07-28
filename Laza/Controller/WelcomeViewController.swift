//
//  WelcomeViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

struct LoginResponse: Codable {
    let token: String // API memberikan token respons
}

class WelcomeViewController: UIViewController {
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var userNameTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        login()
    }
    
    func login() {
        guard let username = userNameTf.text,
              let password = passwordTf.text else {
            return
        }
        
        let urlString = "https://fakestoreapi.com/auth/login"
        guard let url = URL(string: urlString) else {
            print("URL tidak valid")
            return
        }
        
        let userData: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Kirim permintaan menggunakan URLSession
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    // Tangani kesalahan di sini (misalnya, tampilkan pesan peringatan)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Gagal melakukan koneksi ke server.")
                    }
                    return
                }
                
                if let data = data {
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        print("Login berhasil. Token: \(loginResponse.token)")
                        
                        // Jika login berhasil, Anda dapat beralih ke halaman HomeViewController
                        DispatchQueue.main.async {
                            self.goToHome()
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", message: "Data login tidak valid.")
                        }
                    }
                }
            }.resume()
        } catch {
            print("Error creating JSON data: \(error)")
            
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Terjadi kesalahan saat login.")
            }
        }
    }
    
    private func goToHome() {
        // Fungsi untuk beralih ke halaman beranda setelah login berhasil.
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? HomeViewController {
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
