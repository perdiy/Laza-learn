//
//  NewPasswordViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/08/23.
//

import UIKit

class NewPasswordViewController: UIViewController {
    
    var viewModel = NewPasswordViewModel()
    
    var iconClick = true
    var emailNewPass: String?
    var verificationCode: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
            print("No email or verification code.")
            return
        }
        
        guard let newPassword = passwordTf.text, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter a new password.")
            return
        }
        
        guard let confirmPassword = confirmPasswordTf.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please confirm the new password.")
            return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        viewModel.resetPassword(email: email, code: code, newPassword: newPassword, confirmPassword: confirmPassword)
        viewModel.resetPasswordCompletion = { [weak self] success, message in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                
                if success {
                    self?.navigateToSuccessScreen()
                    self?.showAlert(title: "Success", message: message)
                } else {
                    self?.showAlert(title: "Warning", message: message)
                }
            }
        }
    }
    
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
