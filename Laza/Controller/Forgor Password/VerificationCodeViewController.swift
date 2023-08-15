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
        guard let email = emailUser else {
            showAlert(title: "Error", message: "Tidak ada email yang diatur.")
            return
        }
        verifyCode()
    }
    
    func verifyCode() {
        guard let email = emailUser else {
            print("No email received.")
            return
        }
        
        let code = verifycationTf.text ?? ""
        
        let postData: [String: Any] = [
            "email": email,
            "code": code
        ]
        
        let url = URL(string: "https://lazaapp.shop/auth/recover/code")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 202 {
                        DispatchQueue.main.async {
                            self.navigateToNewPassword(email: email, verificationCode: code)
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
                } else {
                    self.showAlert(title: "Error", message: "An error occurred.")
                }
            }
            task.resume()
        } catch {
            showAlert(title: "Error", message: "An error occurred.")
        }
    }
    
    func navigateToNewPassword(email: String, verificationCode: String) {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let newPasswordVC = storyboard.instantiateViewController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController {
            newPasswordVC.emailUser = email
            newPasswordVC.verificationCode = verificationCode
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
