//
//  ForgotPwdViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class ForgotPwdViewController: UIViewController {
    
    var viewmodel = ForgotPwdViewModel()
    
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
        guard let email = emailTf.text, isValidEmail(email) else {
            showAlert(title: "Error", message: "Format email tidak valid.")
            return
        }
        
        viewmodel.resetPassword(email: email)
        viewmodel.resetPasswordCompletion = { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.navigateToVerificationCode(email: email)
                    self?.showAlert(title: "Success", message: message)
                } else {
                    self?.showAlert(title: "Warning", message: message)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        emailTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        validateEmailTextField()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
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
    
    private func navigateToVerificationCode(email: String) {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let verificationCodeVC = storyboard.instantiateViewController(withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController {
            verificationCodeVC.emailUser = email
            navigationController?.pushViewController(verificationCodeVC, animated: true)
        }
    }
}
