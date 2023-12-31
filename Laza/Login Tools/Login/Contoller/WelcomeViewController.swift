//
//  WelcomeViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    var iconClick = true
    var welcomeViewModel = WelcomeViewModel()
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    @IBAction func toggleRemember(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "RememberMe")
            UserDefaults.standard.set(userNameTf.text, forKey: "SavedUsername")
            UserDefaults.standard.set(passwordTf.text, forKey: "SavedPassword")
            
        } else {
            UserDefaults.standard.set(false, forKey: "RememberMe")
            UserDefaults.standard.removeObject(forKey: "SavedUsername")
            UserDefaults.standard.removeObject(forKey: "SavedPassword")
        }
    }
    
    @IBOutlet weak var strongPassword: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
            passwordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var userNameTf: UITextField! {
        didSet {
            userNameTf.addShadow(color: .gray, widht: 0.5, text: userNameTf)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        navigationItem.hidesBackButton = true
        userNameTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        validateTextFields()
        checkLoggedIn()
        strongPassword.isHidden = true
    }
    
    private func checkLoggedIn() {
        if let userToken = KeychainManager.shared.getAccessToken() {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            if let myProfileVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                myProfileVC.userToken = userToken
                navigationController?.pushViewController(myProfileVC, animated: false)
            }
        }
    }
    
    @IBAction func hidePassword(_ sender: Any) {
        iconClick.toggle()
        passwordTf.isSecureTextEntry = !iconClick
    }
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        navigateToForgotPassword()
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        loginAndGetData()
    }
    
    // Fungsi untuk melakukan login dan mendapatkan data
    func loginAndGetData() {
        // Mengambil nilai dari field
        let username = userNameTf.text ?? ""
        let password = passwordTf.text ?? ""
        
        // Memanggil ViewModel untuk mengelola permintaan login
        welcomeViewModel.getDataLogin(username: username, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // Jika login berhasil, ambil data profil pengguna
                self.welcomeViewModel.getUserProfile { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let profileUser):
                        // Jika data profil pengguna berhasil diambil
                        guard let dataProfile = profileUser else { return }
                        // Menyimpan data profil pengguna di penyimpanan aman (Keychain)
                        KeychainManager.shared.saveDataProfile(profile: dataProfile)
                        print("data profile", dataProfile)
                        DispatchQueue.main.async {
                            // Navigasi ke halaman utama aplikasi
                            self.goToHome(userProfile: nil)
                        }
                    case .failure(let errorr):
                        print("erorr mas\(errorr.localizedDescription)")
                    }
                }
            case .failure(let error):
                // Jika terjadi kesalahan dalam login, tampilkan pesan kesalahan
                self.welcomeViewModel.apiAlertLogin = { [weak self] status, description in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        if description == "please verify your account" {
                            // Jika pesan kesalahan adalah "please verify your account"
                            print("ini verify email \(description)")
                            // Tampilkan opsi untuk mengirim ulang email verifikasi
                            let refreshAlert = UIAlertController(title: "Failed Login", message: "\(description), Send Again Verification Account", preferredStyle: UIAlertController.Style.alert)
                            
                            // Menambahkan tindakan "Send" untuk mengirim ulang email verifikasi
                            refreshAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self] (action: UIAlertAction!) in
                                guard let self = self else { return }
                                let storyboard = UIStoryboard(name: "VerifycationEmail", bundle: nil)
                                if let sendEmailVC = storyboard.instantiateViewController(withIdentifier: "VerifycationEmailViewController") as? VerifycationEmailViewController {
                                    self.navigationController?.pushViewController(sendEmailVC, animated: true)
                                }
                            }))
                            
                            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                refreshAlert.dismiss(animated: true, completion: nil)
                            }))
                            
                            self.present(refreshAlert, animated: true, completion: nil)
                        } else {
                            ShowAlert.signUpApi(on: self, title: "Notification \(status)", message: description)
                        }
                        print("JSON Login Error: \(error)")
                    }
                }
            }
        }
    }
    
    
    private func goToHome(userProfile: DataUseProfile?) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            homeVC.userProfile = userProfile
            navigationController?.pushViewController(homeVC, animated: true)
            
            let successAlert = UIAlertController(title: "Login Successful", message: "Anda telah berhasil login!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            successAlert.addAction(okAction)
            homeVC.present(successAlert, animated: true, completion: nil)
        }
    }
    @objc func textFieldDidChange() {
        validateTextFields()
        validatePasswordField()
    }
    
    private func validateTextFields() {
        guard let username = userNameTf.text, !username.isEmpty,
              let password = passwordTf.text, !password.isEmpty else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
            loginButton.backgroundColor = .gray
            return
        }
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
        loginButton.backgroundColor = UIColor(red: 151/255, green: 117/255, blue: 250/255, alpha: 1.0)
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
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToForgotPassword() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let forgotPwdVC = storyboard.instantiateViewController(withIdentifier: "ForgotPwdViewController") as? ForgotPwdViewController {
            navigationController?.pushViewController(forgotPwdVC, animated: true)
        }
    }
}






