//
//  ForgotPwdViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class ForgotPwdViewController: UIViewController {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var emailTf: UITextField! {
        didSet {
            emailTf.addShadow(color: .gray, widht: 0.5, text: emailTf)
        }
    }
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emailBtn(_ sender: Any) {
        // Validate the email format using regex
        guard let email = emailTf.text, isValidEmail(email) else {
            showAlert(title: "Error", message: "Format email tidak valid ")
            return
        }
        
        // Perform the action after validating the email format
        signUp(email: email)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Tambahkan target untuk text field untuk melakukan validasi saat text berubah
        emailTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Lakukan validasi awal
        validateEmailTextField()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc func textFieldDidChange() {
        validateEmailTextField()
    }
    
    private func validateEmailTextField() {
        guard let email = emailTf.text, !email.isEmpty else {
            emailBtn.isEnabled = false
            emailBtn.alpha = 0.5
            emailBtn.backgroundColor = .gray
            return
        }
        emailBtn.isEnabled = true
        emailBtn.alpha = 1.0
        emailBtn.backgroundColor = UIColor(red: 151/255, green: 117/255, blue: 250/255, alpha: 1.0)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    func signUp(email: String) {
        let postData: [String: Any] = ["email": email]
        
        guard let url = URL(string: "https://lazaapp.shop/auth/forgotpassword") else {
            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Gagal melakukan koneksi ke server.")
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.navigateToVerificationCode(email: email)
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
                }
            }
            task.resume()
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Terjadi kesalahan saat mengirim data.")
            }
        }
    }
    
    private func navigateToVerificationCode(email: String) {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let verificationCodeVC = storyboard.instantiateViewController(withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController {
            verificationCodeVC.emailUser = email
            navigationController?.pushViewController(verificationCodeVC, animated: true)
        }
    }

}
