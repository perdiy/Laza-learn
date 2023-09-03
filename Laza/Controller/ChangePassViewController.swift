//
//  ChangePassViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/09/23.
// 

import UIKit

class ChangePassViewController: UIViewController {
    
    @IBOutlet weak var oldPaswordTf: UITextField! {
        didSet {
            oldPaswordTf.addShadow(color: .gray, widht: 0.5, text: oldPaswordTf)
            oldPaswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var viewBack: UIView!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var newPasswordTf: UITextField! {
        didSet {
            newPasswordTf.addShadow(color: .gray, widht: 0.5, text: newPasswordTf)
            newPasswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            confirmPasswordTf.addShadow(color: .gray, widht: 0.5, text: confirmPasswordTf)
            confirmPasswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var strongConfirmPassLb: UILabel!
    @IBOutlet weak var storngNewPassLb: UILabel!
    @IBOutlet weak var buttonChangePassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        textFieldDidChange()
    }
    
    @objc func textFieldDidChange() {
        let oldPasswordIsEmpty = oldPaswordTf.text?.isEmpty ?? true
        let newPasswordIsEmpty = newPasswordTf.text?.isEmpty ?? true
        let confirmPasswordIsEmpty = confirmPasswordTf.text?.isEmpty ?? true
        
        buttonChangePassword.isEnabled = !oldPasswordIsEmpty && !newPasswordIsEmpty && !confirmPasswordIsEmpty
        buttonChangePassword.alpha = buttonChangePassword.isEnabled ? 1.0 : 0.5
        storngNewPassLb.isHidden = !(newPasswordTf.text?.count ?? 0 >= 8)
        strongConfirmPassLb.isHidden = !(confirmPasswordTf.text?.count ?? 0 >= 8)
        
        if let newPassword = newPasswordTf.text, let confirmPassword = confirmPasswordTf.text {
            if newPassword == confirmPassword {
                
            } else {
                
            }
        }
    }
    
    
    
    @IBAction func buttonChangePasswordTapped(_ sender: Any) {
        guard let oldPassword = oldPaswordTf.text,
              let newPassword = newPasswordTf.text,
              let confirmPassword = confirmPasswordTf.text,
              let token = KeychainManager.shared.getAccessToken() else {
            showAlert(message: "Harap isi semua kolom atau token tidak ditemukan.")
            return
        }
        
        if newPassword == confirmPassword {
            updatePassword(oldPassword: oldPassword, newPassword: newPassword, rePassword: confirmPassword, token: token)
        } else {
            showAlert(message: "Kata sandi baru dan konfirmasi kata sandi tidak cocok.")
        }
    }
    
    private func updatePassword(oldPassword: String, newPassword: String, rePassword: String, token: String) {
        // Mempersiapkan permintaan PUT ke API
        let apiUrl = "https://lazaapp.shop/user/change-password"
        guard let url = URL(string: apiUrl) else {
            showAlert(message: "URL API tidak valid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        let parameters: [String: Any] = [
            "old_password": oldPassword,
            "new_password": newPassword,
            "re_password": rePassword
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            showAlert(message: "Gagal menyiapkan permintaan.")
            return
        }
        
        // Mengirim permintaan
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                self?.showAlert(message: "Error permintaan: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self?.showAlert(message: "Respon tidak valid dari server.")
                return
            }
            
            // Kata sandi berhasil diubah
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }.resume()
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Change Password", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

}
