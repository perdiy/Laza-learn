//
//  VerificationCodeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit
import DPOTPView

class VerificationCodeViewController: UIViewController {
    
    var remainingTimeInSeconds = 300 // 5 menit
    var countdownTimer: Timer?
    var emailUser: String?
    var viewModel = VerificationCodeViewModel()
    
    @IBOutlet weak var waktuVerifikasi: UILabel!
    @IBOutlet weak var verifycationTf: DPOTPView!
    
    @IBOutlet weak var labelHitungMundul: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        startCountdown() 
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
    
    func startCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }

    @objc func updateCountdownLabel() {
        if remainingTimeInSeconds > 0 {
            remainingTimeInSeconds -= 1
            let minutes = remainingTimeInSeconds / 60
            let seconds = remainingTimeInSeconds % 60
            labelHitungMundul.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            stopCountdown()
        }
    }

    func stopCountdown() {
        countdownTimer?.invalidate()
        labelHitungMundul.text = "Waktu habis"
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
