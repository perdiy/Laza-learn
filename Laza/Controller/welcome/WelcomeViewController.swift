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
    // hide or no text password
    var iconClick = true
    @IBAction func hidePassword(_ sender: Any) {
        if iconClick {
            iconClick = true
            passwordTf.isSecureTextEntry = false
        } else {
            iconClick = false
            passwordTf.isSecureTextEntry = true
        }
        iconClick = !iconClick
        
    }
    
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        navigateToForgotPassword()
    }
    
    
    // Outlets untuk dua text field di layar
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
        }
    }
    
    @IBOutlet weak var userNameTf: UITextField! {
        didSet {
            userNameTf.addShadow(color: .gray, widht: 0.5, text: userNameTf)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sembunyikan tombol "Back" pada navigasi bar
        navigationItem.hidesBackButton = true
        
        // Tambahkan target untuk text field untuk melakukan validasi saat text berubah
        userNameTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Lakukan validasi awal
        validateTextFields()
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        login()
    }
    
    // Fungsi untuk melakukan login
    func login() {
        // Ambil nilai dari text field untuk username dan password
        guard let username = userNameTf.text, let password = passwordTf.text, !username.isEmpty, !password.isEmpty else {
            showAlert(title: "Error", message: "Username dan password tidak boleh kosong.")
            return
        }
        
        // URL untuk endpoint login API
        let urlString = "https://fakestoreapi.com/auth/login"
        guard let url = URL(string: urlString) else {
            print("URL tidak valid")
            return
        }
        
        // Data yang akan dikirim sebagai body request (username dan password)
        let userData: [String: Any] = ["username": username, "password": password]
        
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
    
    // Fungsi untuk mengaktifkan atau menonaktifkan tombol login berdasarkan validasi text field
    @objc func textFieldDidChange() {
        validateTextFields()
    }
    
    private func validateTextFields() {
        // Jika salah satu text field kosong, nonaktifkan tombol login dan beri warna abu-abu
        guard let username = userNameTf.text, !username.isEmpty,
              let password = passwordTf.text, !password.isEmpty else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
            loginButton.backgroundColor = .gray
            return
        }
        // Jika kedua text field tidak kosong, aktifkan tombol login dan beri warna khusus
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
        loginButton.backgroundColor = UIColor(red: 151/255, green: 117/255, blue: 250/255, alpha: 1.0)
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
    
    private func navigateToForgotPassword() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let forgotPwdVC = storyboard.instantiateViewController(withIdentifier: "ForgotPwdViewController") as? ForgotPwdViewController {
            navigationController?.pushViewController(forgotPwdVC, animated: true)
        }
    }
}
