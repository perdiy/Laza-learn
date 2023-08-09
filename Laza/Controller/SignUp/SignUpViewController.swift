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
        if iconClick {
            iconClick = true
            phoneTf.isSecureTextEntry = false
        } else {
            iconClick = false
            phoneTf.isSecureTextEntry = true
        }
        iconClick = !iconClick
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
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
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
        
        // Tambahkan target untuk text field untuk melakukan validasi saat text berubah
        userNameTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Lakukan validasi awal
        validateTextFields()
    }
    
    private func signUp() {
        guard let userName = userNameTf.text,
              let email = emailTf.text,
              let phone = phoneTf.text,
              let password = passwordTf.text else {
            return
        }
        
        // Check if password and confirm password match
        guard password == phoneTf.text else {
            showAlert(title: "Password Mismatch", message: "Kata sandi dan konfirmasi kata sandi tidak cocok.")
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
            showAlert(title: "Invalid Email", message: "Silakan isi alamat email. Contoh : perdi@gmail.com")
        } else if !isPasswordValid {
            showAlert(title: "Invalid Password", message: "Kata sandi harus minimal 8 karakter dan mengandung setidaknya satu huruf dan satu angka. Contoh: HelloWorld99")
        } else {
            
            // Cek apakah data pengguna sudah ada dalam UserDefaults
            let userDefaults = UserDefaults.standard
            let savedUserName = userDefaults.string(forKey: "userName")
            if savedUserName == userName {
                // Tampilkan pesan kesalahan jika data pengguna sudah ada
                showAlert(title: "Registration Failed", message: "Nama pengguna sudah digunakan. Harap gunakan nama pengguna yang berbeda.")
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
                    
                    // Navigate to NestedViewController
                    self.navigateToNestedViewController()
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func navigateToNestedViewController() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let nestedViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {
            fatalError("erorr")
        }
        navigationController?.pushViewController(nestedViewController, animated: true)
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
    
    @objc private func textFieldDidChange() {
        validateTextFields()
    }
    
    private func validateTextFields() {
        // Jika salah satu text field kosong, nonaktifkan tombol sign up dan beri warna abu-abu
        guard let userName = userNameTf.text, !userName.isEmpty,
              let email = emailTf.text, !email.isEmpty,
              let phone = phoneTf.text, !phone.isEmpty,
              let password = passwordTf.text, !password.isEmpty else {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
            signUpButton.backgroundColor = UIColor.gray
            return
        }
        signUpButton.isEnabled = true
        signUpButton.alpha = 1.0
        signUpButton.backgroundColor = UIColor(red: 151/255, green: 117/255, blue: 250/255, alpha: 1.0)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
