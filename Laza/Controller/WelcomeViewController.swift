//
//  WelcomeViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

// Struct untuk mendefinisikan respons dari login API
struct LoginResponse: Codable {
    let token: String
}

class WelcomeViewController: UIViewController {
    // Outlets untuk dua text field di layar
    @IBOutlet weak var passwordTf: UITextField! {
        didSet{
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
        }
    }
    
    @IBOutlet weak var userNameTf: UITextField! {
        didSet{
            userNameTf.addShadow(color: .gray, widht: 0.5, text: userNameTf)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sembunyikan tombol "Back" pada navigasi bar
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        login()
    }
    
    // Fungsi untuk melakukan login
    func login() {
        // Ambil nilai dari text field untuk username dan password
        guard let username = userNameTf.text,
              let password = passwordTf.text else {
            return
        }
        
        // URL untuk endpoint login API
        let urlString = "https://fakestoreapi.com/auth/login"
        guard let url = URL(string: urlString) else {
            print("URL tidak valid")
            return
        }
        
        // Data yang akan dikirim sebagai body request (username dan password)
        let userData: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        do {
            // Serialize data ke dalam bentuk JSON
            let jsonData = try JSONSerialization.data(withJSONObject: userData)
            
            // Konfigurasi request untuk login
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
                        // Parse data JSON menjadi objek LoginResponse
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        print("Login berhasil. Token: \(loginResponse.token)")
                        
                        // Simpan token ke UserDefaults untuk penggunaan berikutnya
                        UserDefaults.standard.set(loginResponse.token, forKey: "token")
                        // Simpan username dan password ke UserDefaults untuk penggunaan berikutnya
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
                        
                        // Jika login berhasil, beralih ke halaman HomeViewController
                        DispatchQueue.main.async {
                            self.goToHome()
                            self.showAlert(title: "Success", message: "Login berhasil.")
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
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
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
