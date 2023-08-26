//
//  WelcomeViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    var iconClick = true
    var welcomeViewModel = WelcomeViewModel()
    
    
    @IBAction func toggleRemember(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "RememberMe")
            UserDefaults.standard.set(userNameTf.text, forKey: "SavedUsername")
            UserDefaults.standard.set(passwordTf.text, forKey: "SavedPassword")
            
        } else {
            UserDefaults.standard.set(false, forKey: "RememberMe")
            UserDefaults.standard.removeObject(forKey: "SavedUsername")
            UserDefaults.standard.removeObject(forKey: "SavedPassword")
        }
    }

    @IBOutlet weak var strongPassword: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
            passwordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        
        activityIndicator.isHidden = true
        
        navigationItem.hidesBackButton = true
        userNameTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        guard let username = userNameTf.text, let password = passwordTf.text else {
            return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        welcomeViewModel.signUp(username: username, password: password)
        welcomeViewModel.loginCompletion = { [weak self] success in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                
                if success {
                    self?.goToHome()
                } else {
                    self?.showAlert(message: "Login failed. Please check your credentials.")
                }
            }
        }
    }
    
    @objc func textFieldDidChange() {
        validateTextFields()
        validatePasswordField()
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
    
    private func validatePasswordField() {
        guard let password = passwordTf.text, !password.isEmpty else {
            strongPassword.isHidden = true
            return
        }
        
        if ValidationUtil.isValidPassword(password) {
            strongPassword.isHidden = false
        } else {
            strongPassword.isHidden = true
        }
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