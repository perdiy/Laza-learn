//
//  SignUpViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // var action button hide
    var iconClick = true
    
    @IBAction func hidePasswordBtn(_ sender: Any) {
        if iconClick {
            iconClick = true
            passwordTf.isSecureTextEntry = false
        } else {
            iconClick = false
            passwordTf.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    
    @IBAction func hideConfirmBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var userNameTf: UITextField! {
        didSet {
            userNameTf.addShadow(color: .gray, widht: 0.5, text: userNameTf)
        }
    }
    
    @IBOutlet weak var emailTf: UITextField! {
        didSet {
            emailTf.addShadow(color: .gray, widht: 0.5, text: emailTf)
        }
    }
    
    // passwor confirm
    @IBOutlet weak var phoneTf: UITextField! {
        didSet {
            phoneTf.addShadow(color: .gray, widht: 0.5, text: phoneTf)
        }
    }
    
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpBtn(_ sender: Any) {
        signUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    private func signUp() {
        guard let userName = userNameTf.text,
              let email = emailTf.text,
              let phone = phoneTf.text,
              let password = passwordTf.text else {
            return
        }
        
        // Validate email regex
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        
        // Validate password regex
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isPasswordValid = passwordPredicate.evaluate(with: password)
        
        // Check if the entered email and password are valid
        if !isEmailValid {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
        } else if !isPasswordValid {
            showAlert(title: "Invalid Password", message: "Password must be at least 8 characters long and contain at least one letter and one number.")
        } else {
            // Rest of your sign-up logic goes here...
            // Cek apakah data pengguna sudah ada dalam UserDefaults
            let userDefaults = UserDefaults.standard
            let savedUserName = userDefaults.string(forKey: "userName")
            if savedUserName == userName {
                // Tampilkan pesan kesalahan jika data pengguna sudah ada
                showAlert(title: "Registration Failed", message: "Username is already taken. Please use a different username.")
            } else {
                // Jika data pengguna belum ada, simpan data ke UserDefaults
                userDefaults.set(userName, forKey: "userName")
                userDefaults.set(email, forKey: "email")
                userDefaults.set(phone, forKey: "phone")
                userDefaults.set(password, forKey: "password")
                userDefaults.synchronize()
                
                // Reset TextField
                userNameTf.text = ""
                emailTf.text = ""
                phoneTf.text = ""
                passwordTf.text = ""
                
                // Tampilkan pesan keberhasilan menggunakan UIAlertController
                let alertController = UIAlertController(title: "Registration Successful", message: "Account has been created!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    // Print data yang sudah ditambahkan ke UserDefaults
                    self.printUserData()
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func printUserData() {
        // Ambil data dari UserDefaults
        let userDefaults = UserDefaults.standard
        if let userName = userDefaults.string(forKey: "userName"),
           let email = userDefaults.string(forKey: "email"),
           let phone = userDefaults.string(forKey: "phone"),
           let password = userDefaults.string(forKey: "password") {
            // Cetak data ke konsol
            print("Data yang ditambahkan ke UserDefaults:")
            print("Username: \(userName)")
            print("Email: \(email)")
            print("Phone: \(phone)")
            print("Password: \(password)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
