//
//  ForgotPwdViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class ForgotPwdViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
        // Melakukan validasi format email
        guard let email = emailTf.text, isValidEmail(email) else {
            showAlert(title: "Error", message: "Invalid email format.")
            return
        }
        
        // Menampilkan indikator aktivitas
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // Memanggil fungsi resetPassword dari viewmodel
        viewmodel.resetPassword(email: email)
        viewmodel.resetPasswordCompletion = { [weak self] success, message in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                // Menampilkan pesan berdasarkan hasil reset password
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
        
        // Menyembunyikan indikator aktivitas
        activityIndicator.isHidden = true
        
        // Menambahkan shadow dan konfigurasi tampilan tombol email
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Menambahkan target untuk memantau perubahan teks pada emailTf
        emailTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        validateEmailTextField()
    }
    
    // Fungsi untuk memvalidasi format email menggunakan regular expression
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc func textFieldDidChange() {
        validateEmailTextField()
    }
    
    // Fungsi untuk mengatur tampilan tombol email berdasarkan validitas email
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
    
    // Fungsi untuk menampilkan pesan alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Fungsi untuk berpindah ke halaman verifikasi kode
    private func navigateToVerificationCode(email: String) {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let verificationCodeVC = storyboard.instantiateViewController(withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController {
            verificationCodeVC.emailUser = email
            navigationController?.pushViewController(verificationCodeVC, animated: true)
        }
    }
}
