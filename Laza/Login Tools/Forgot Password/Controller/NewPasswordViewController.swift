//
//  NewPasswordViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/08/23.
//

import UIKit

class NewPasswordViewController: UIViewController {
    
    // ViewModel untuk mengatur logika tampilan
    var viewModel = NewPasswordViewModel()
    
    // Variabel untuk mengatur visibilitas password
    var iconClick = true
    
    // Variabel untuk menyimpan email dan kode verifikasi
    var emailNewPass: String?
    var verificationCode: String?
    
    // Indikator aktivitas saat mengirim permintaan reset password
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Teksfield untuk memasukkan password baru
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            // Menambahkan shadow pada textfield
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
        }
    }
    
    // Teksfield untuk memasukkan konfirmasi password baru
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            // Menambahkan shadow pada textfield
            confirmPasswordTf.addShadow(color: .gray, widht: 0.5, text: confirmPasswordTf)
        }
    }
    
    // Tampilan untuk tombol back
    @IBOutlet weak var viewBack: UIView!
    
    // Aksi saat tombol back ditekan
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Aksi saat tombol reset password ditekan
    @IBAction func resetPasswordBtn(_ sender: Any) {
        resetPassword()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menampilkan indikator aktivitas
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        viewBack.applyCircularButtonStyle()
        viewBack.applyShadow()
    }
    
    // Fungsi untuk mengirim permintaan reset password
    func resetPassword() {
        // Memastikan email dan kode verifikasi tidak kosong
        guard let email = emailNewPass, let code = verificationCode else {
            print("No email or verification code.")
            return
        }
        
        // Memastikan password baru tidak kosong
        guard let newPassword = passwordTf.text, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter a new password.")
            return
        }
        
        // Memastikan konfirmasi password baru tidak kosong
        guard let confirmPassword = confirmPasswordTf.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please confirm the new password.")
            return
        }
        
       
        
        // Memanggil fungsi resetPassword dari viewmodel
        viewModel.resetPassword(email: email, code: code, newPassword: newPassword, confirmPassword: confirmPassword)
        viewModel.resetPasswordCompletion = { [weak self] success, message in
            DispatchQueue.main.async {
                // Menghentikan indikator aktivitas
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                
                // Menampilkan pesan berdasarkan hasil reset password
                if success {
                    self?.navigateToSuccessScreen()
                    self?.showAlert(title: "Success", message: message)
                } else {
                    self?.showAlert(title: "Warning", message: message)
                }
            }
        }
    }
    
    // Fungsi untuk berpindah ke halaman sukses
    func navigateToSuccessScreen() {
        if let successViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(successViewController, animated: true)
        }
    }
    
    // Fungsi untuk menampilkan pesan alert
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
