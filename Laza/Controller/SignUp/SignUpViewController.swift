//
//  SignUpViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//
import UIKit

class SignUpViewController: UIViewController {
    
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
    
    @IBAction func hideConfirmPssword(_ sender: Any) {
        if iconClick {
            iconClick = true
            confirmPasswordTf.isSecureTextEntry = false
        } else {
            iconClick = false
            confirmPasswordTf.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBOutlet weak var userNameTf: UITextField!{
        didSet {
            userNameTf.addShadow(color: .gray, widht: 0.5, text: userNameTf)
        }
    }
    
    @IBOutlet weak var emailTf: UITextField!{
        didSet {
            emailTf.addShadow(color: .gray, widht: 0.5, text: emailTf)
        }
    }
    
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
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
            signUpButton.backgroundColor = .gray
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        signUp()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    private func setupTextFields() {
        userNameTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        validateTextFields()
    }
    
    @objc func textFieldDidChange() {
        validateTextFields()
    }
    
    private func validateTextFields() {
        guard let username = userNameTf.text, !username.isEmpty,
              let email = emailTf.text, !email.isEmpty,
              let password = passwordTf.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTf.text, !confirmPassword.isEmpty else {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
            return
        }
        signUpButton.isEnabled = true
        signUpButton.alpha = 1.0
        
    }
    // Function to handle signing up
    func signUp() {
        guard let username = userNameTf.text, !username.isEmpty,
              let email = emailTf.text, !email.isEmpty,
              let password = passwordTf.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTf.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        let postData: [String: Any] = [
            "full_name": username,
            "username": username,
            "email": email,
            "password": password
            // You can add more data if needed
        ]
        
        let url = URL(string: "https://lazaapp.shop/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        // Registrasi berhasil
                        DispatchQueue.main.async {
                            self.showAlert(message: "Registration successful!")
                            self.navigateToWelcome()
                        }
                        print("JSO SignUP")
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
    func navigateToWelcome() {
        guard let welcomeViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        navigationController?.pushViewController(welcomeViewController, animated: true)
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
