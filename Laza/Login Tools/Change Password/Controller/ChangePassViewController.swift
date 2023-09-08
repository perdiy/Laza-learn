//
//  ChangePassViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/09/23.
//

import UIKit


class ChangePassViewController: UIViewController {
    
    private let viewModel = ChangePasswordModel()
    var iconClick = true
    
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
    
    @IBAction func hideOldPassword(_ sender: Any) {
        iconClick.toggle()
        oldPaswordTf.isSecureTextEntry = !iconClick
    }
    @IBAction func hideNewPassword(_ sender: Any) {
        iconClick.toggle()
        newPasswordTf.isSecureTextEntry = !iconClick
    }
    @IBAction func hideConfirmPassword(_ sender: Any) {
        iconClick.toggle()
        confirmPasswordTf.isSecureTextEntry = !iconClick
    }
    
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
        putChangePassword()
        
    }
    
    func putChangePassword() {
        let oldPassword = oldPaswordTf.text ?? ""
        let newPassword = newPasswordTf.text ?? ""
        let confirmNewPassword = confirmPasswordTf.text ?? ""
        viewModel.getPass(oldPassword: oldPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) { result in
            switch result {
            case .success(let json):
                // Panggil metode untuk berpindah ke view controller selanjutnya
                self.viewModel.alertChangePassword = { successMessage in
                    DispatchQueue.main.async {
                        // Tampilkan alert ketika berhasil mengganti kata sandi
                        let successAlert = UIAlertController(title: "Success", message: successMessage, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            // Kembali ke tampilan sebelumnya atau lakukan navigasi yang sesuai
                            self.navigationController?.popViewController(animated: true)
                        })
                        successAlert.addAction(okAction)
                        self.present(successAlert, animated: true, completion: nil)
                    }
                }
                print("Response JSON: \(String(describing: json))")
            case .failure(let error):
                self.viewModel.alertChangePassword = { description in
                    DispatchQueue.main.async {
                        print("Alert showing for failure case - errorMessage: \(description)")
                        ShowAlert.forgotPassApi(on: self, title: "Error Message", message: description)
                    }
                }
                print("Error: \(error)")
                // Handle error appropriately
            }
        }
    }
}
