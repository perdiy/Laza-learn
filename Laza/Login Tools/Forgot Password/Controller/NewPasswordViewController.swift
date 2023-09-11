//
//  NewPasswordViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/08/23.
//

import UIKit

class NewPasswordViewController: UIViewController {
    var iconClick = true
    
    @IBAction func hidePasswordbtn(_ sender: Any) {
        iconClick.toggle()
        passwordTf.isSecureTextEntry = !iconClick
    }
    
    @IBAction func hideConfirmPass(_ sender: Any) {
        iconClick.toggle()
        confirmPasswordTf.isSecureTextEntry = !iconClick
    }
    @IBOutlet weak var strongPass: UILabel!
    @IBOutlet weak var strongConfirmPass: UILabel!
    
    // ViewModel untuk mengatur logika tampilan
    var viewModel = NewPasswordViewModel()
    
    
    // Variabel untuk menyimpan email dan kode verifikasi
    var emailNewPass: String?
    var verificationCode: String?
    
    // Teksfield untuk memasukkan password baru
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            // Menambahkan shadow pada textfield
            passwordTf.addShadow(color: .gray, width: 0.5, text: passwordTf)
            passwordTf.delegate = self // Mengatur delegate untuk passwordTf
        }
    }
    
    // Teksfield untuk memasukkan konfirmasi password baru
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            // Menambahkan shadow pada textfield
            confirmPasswordTf.addShadow(color: .gray, width: 0.5, text: confirmPasswordTf)
        }
    }
    
    // Aksi saat tombol reset password ditekan
    @IBAction func resetPasswordBtn(_ sender: Any) {
        resetPassword()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strongPass.isHidden = true
        strongConfirmPass.isHidden = true // Sembunyikan strongConfirmPass label
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
        // [weak self] Ini akan membantu menghindari potensi masalah seperti strong reference cycle.
        viewModel.resetPasswordCompletion = { [weak self] success, message in
            DispatchQueue.main.async {
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

// Ekstensi untuk mengimplementasikan UITextFieldDelegate
extension NewPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTf {
            // Menghitung panjang teks saat ini dalam passwordTf
            let currentText = (textField.text ?? "") as NSString
            let newText = currentText.replacingCharacters(in: range, with: string) as String
            
            // Memeriksa jika panjang teks mencapai 8 karakter atau lebih
            if newText.count >= 8 {
                strongPass.isHidden = false // Menampilkan strongPass label
            } else {
                strongPass.isHidden = true // Sembunyikan strongPass label jika kurang dari 8 karakter
            }
        } else if textField == confirmPasswordTf {
            // Menghitung panjang teks saat ini dalam confirmPasswordTf
            let currentText = (textField.text ?? "") as NSString
            let newText = currentText.replacingCharacters(in: range, with: string) as String
            
            // Memeriksa jika panjang teks mencapai 8 karakter atau lebih
            if newText.count >= 8 {
                strongConfirmPass.isHidden = false // Menampilkan strongConfirmPass label
            } else {
                strongConfirmPass.isHidden = true // Sembunyikan strongConfirmPass label jika kurang dari 8 karakter
            }
        }
        
        return true
    }
}
