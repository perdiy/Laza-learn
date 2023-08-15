//
//  WelcomeViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//
import UIKit

struct LoginResponse: Codable {
    let token: String
}

class WelcomeViewController: UIViewController {
    
    var iconClick = true
    
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
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        userNameTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        validateTextFields()
    }
    
    @IBAction func hidePassword(_ sender: Any) {
        iconClick.toggle()
        passwordTf.isSecureTextEntry = !iconClick
    }
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        navigateToForgotPassword()
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        signUp()
    }
    
    func signUp() {
        guard let username = userNameTf.text, !username.isEmpty,
              let password = passwordTf.text, !password.isEmpty else {
            showAlert( message: "Please fill in all fields.")
            return
        }
        
        let postData: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        let url = URL(string: "https://lazaapp.shop/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.goToHome()
                        }
                    } else {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let errorMessage = json?["description"] as? String {
                                    DispatchQueue.main.async {
                                        self.showAlert(message: errorMessage)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showAlert(message: "An error occurred.")
                                    }
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    self.showAlert(message: "An error occurred.")
                                }
                            }
                        }
                    }
                } else {
                    self.showAlert(message: "An error occurred.")
                }
            }
            task.resume()
        } catch {
            showAlert(message: "An error occurred.")
        }
    }
    @objc func textFieldDidChange() {
        validateTextFields()
    }
    
    private func validateTextFields() {
        guard let username = userNameTf.text, !username.isEmpty,
              let password = passwordTf.text, !password.isEmpty else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
            loginButton.backgroundColor = .gray
            return
        }
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
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToForgotPassword() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let forgotPwdVC = storyboard.instantiateViewController(withIdentifier: "ForgotPwdViewController") as? ForgotPwdViewController {
            navigationController?.pushViewController(forgotPwdVC, animated: true)
        }
    }
}
