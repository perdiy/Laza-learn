//
//  SignUpViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var iconClick = true
    var signUpViewModel = SignUpViewModel()
    
    @IBAction func hidePassword(_ sender: Any) {
        iconClick.toggle()
        passwordTf.isSecureTextEntry = !iconClick
    }
    
    @IBAction func hideConfirmPassword(_ sender: Any) {
        iconClick.toggle()
        confirmPasswordTf.isSecureTextEntry = !iconClick
    }
    
    @IBOutlet weak var strongConfirmPassword: UIImageView!
    @IBOutlet weak var strongPassword: UIImageView!
    @IBOutlet weak var cekImg: UIImageView!
    @IBOutlet weak var userNameTf: UITextField! {
        didSet {
            userNameTf.addShadow(color: .gray, widht: 0.5, text: userNameTf)
        }
    }
    
    @IBOutlet weak var emailTf: UITextField! {
        didSet {
            emailTf.addShadow(color: .gray, widht: 0.5, text: emailTf)
            emailTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
            passwordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            confirmPasswordTf.addShadow(color: .gray, widht: 0.5, text: confirmPasswordTf)
            confirmPasswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
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
        validateEmailField()
        validatePasswordField()
        validateConfirmPasswordField()
    }
    
    @objc func textFieldDidChange() {
        validateTextFields()
        validateEmailField()
        validatePasswordField()
        validateConfirmPasswordField()
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
    
    private func validateEmailField() {
        guard let email = emailTf.text, !email.isEmpty else {
            cekImg.isHidden = true
            return
        }
        
        if ValidationUtil.isValidEmail(email) {
            cekImg.isHidden = false
        } else {
            cekImg.isHidden = true
        }
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
    
    private func validateConfirmPasswordField() {
        guard let confirmPassword = confirmPasswordTf.text, !confirmPassword.isEmpty else {
            strongConfirmPassword.isHidden = true
            return
        }
        
        if ValidationUtil.isValidPassword(confirmPassword) {
            strongConfirmPassword.isHidden = false
        } else {
            strongConfirmPassword.isHidden = true
        }
    }
    
    func signUp() {
        guard let username = userNameTf.text, let email = emailTf.text, let password = passwordTf.text, let confirmPassword = confirmPasswordTf.text else {
            return
        }
        
        signUpViewModel.signUp(username: username, email: email, password: password, confirmPassword: confirmPassword)
        signUpViewModel.signUpCompletion = { success, message in
            DispatchQueue.main.async {
                if success {
                    self.navigateToWelcome()
                    self.showAlert(message: message)
                } else {
                    self.showAlert(message: message)
                }
            }
        }
    }
    
    func navigateToWelcome() {
        if let welcomeViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
