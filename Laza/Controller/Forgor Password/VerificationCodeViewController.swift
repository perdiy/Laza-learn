//
//  VerificationCodeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit
import DPOTPView

class VerificationCodeViewController: UIViewController {
    
    @IBOutlet weak var verifycationTf: DPOTPView!
    var emailUser: String?
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    @IBAction func verifyCodeBtn(_ sender: Any) {
        //        guard let email = emailUser else {
        //            showAlert(title: "Error", message: "Tidak ada email yang diatur.")
        //            return
        //        }
        verifyCode()
    }
    
    func verifyCode() {
        guard let email = emailUser else {
            print("No email received.")
            return
        }
        
        guard let code = verifycationTf.text, !code.isEmpty else {
            print("Harap masukkan kode verifikasi.")
            return
        }
        
        sendVerificationRequest(email: email, code: code)
    }
    
    func sendVerificationRequest(email: String, code: String) {
        let url = URL(string: "https://lazaapp.shop/auth/recover/code")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData: [String: Any] = [
            "email": email,
            "code": code
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 202 {
                        DispatchQueue.main.async {
                            self.navigateToNewPassword()
                        }
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    print("Warning: \(errorMessage)")
                                } else {
                                    print("No valid HTTP response received.")
                                    print("Warning: An error occurred.")
                                }
                            } catch {
                                print("Warning: An error occurred.")
                            }
                        }
                    }
                } else {
                    print("Error: Terjadi kesalahan.")
                }
            }
            task.resume()
        } catch {
            print("Error: Terjadi kesalahan.")
        }
    }
    
    func navigateToNewPassword() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let newPasswordVC = storyboard.instantiateViewController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController {
            newPasswordVC.emailNewPass = emailUser
            newPasswordVC.verificationCode = verifycationTf.text
            navigationController?.pushViewController(newPasswordVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
