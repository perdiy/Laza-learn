//
//  VerificationCodeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit
import DPOTPView

class VerificationCodeViewController: UIViewController {
    
    var viewModel = VerificationCodeViewModel()
    
    @IBOutlet weak var waktuVerifikasi: UILabel!
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
            print("No email received.")
            return
        }
        
        guard let code = verifycationTf.text, !code.isEmpty else {
            print("Harap masukkan kode verifikasi.")
            return
        }
        
        viewModel.verifyCode(email: email, code: code)
        viewModel.verifyCodeCompletion = { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.navigateToNewPassword()
                } else {
                    self?.showAlert(title: "Warning", message: message)
                }
            }
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
