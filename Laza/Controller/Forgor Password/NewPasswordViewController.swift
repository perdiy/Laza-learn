//
//  NewPasswordViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/08/23.
//

import UIKit

class NewPasswordViewController: UIViewController {
    
    var iconClick = true
    var emailNewPass: String?
    var verificationCode: String?
    
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
        }
    }
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            confirmPasswordTf.addShadow(color: .gray, widht: 0.5, text: confirmPasswordTf)
        }
    }
    @IBOutlet weak var viewBack: UIView!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordBtn(_ sender: Any) {
        resetPassword()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    func resetPassword() {
        guard let email = emailNewPass, let code = verificationCode else {
            print("Tidak ada email atau kode verifikasi.")
            return
        }
        
        guard let newPassword = passwordTf.text, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Harap masukkan kata sandi baru.")
            return
        }
        
        guard let confirmPassword = confirmPasswordTf.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Harap konfirmasi kata sandi baru.")
            return
        }
        
        if newPassword != confirmPassword {
            showAlert(title: "Error", message: "Kata sandi tidak cocok.")
            return
        }
        
        
        let url = URL(string: "https://lazaapp.shop/auth/recover/password?email=\(email)&code=\(code)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData: [String: Any] = [
            "new_password": newPassword,
            "re_password": confirmPassword
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            // Reset kata sandi berhasil, navigasi ke layar sukses
                            self.navigateToSuccessScreen()
                        }
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    DispatchQueue.main.async {
                                        self.showAlert(title: "Warning", message: errorMessage)
                                    }
                                } else {
                                    print("No valid HTTP response received.")
                                    DispatchQueue.main.async {
                                        self.showAlert(title: "Warning", message: "An error occurred.")
                                    }
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    self.showAlert(title: "Warning", message: "An error occurred.")
                                }
                            }
                        }
                    }
                } else {
                    self.showAlert(title: "Error", message: "Terjadi kesalahan.")
                }
            }
            task.resume()
            print("API request sent")
        } catch {
            showAlert(title: "Error", message: "Terjadi kesalahan.")
        }
    }
    
    // Setelah pengaturan kata sandi baru berhasil
    func navigateToSuccessScreen() {
        if let successViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(successViewController, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
