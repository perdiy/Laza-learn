//
//  SignUpViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTf: UITextField!
    @IBOutlet weak var lastNameTf: UITextField!
    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    @IBAction func signUpBtn(_ sender: Any) {
        signUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func signUp() {
        guard let firstName = firstNameTf.text,
              let lastName = lastNameTf.text,
              let userName = userNameTf.text,
              let email = emailTf.text,
              let phone = phoneTf.text,
              let password = passwordTf.text else {
            return
        }
        
        // Cek apakah data pengguna sudah ada dalam UserDefaults
        let userDefaults = UserDefaults.standard
        let savedUserName = userDefaults.string(forKey: "userName")
        if savedUserName == userName {
            // Tampilkan pesan kesalahan jika data pengguna sudah ada
            let alertController = UIAlertController(title: "Pendaftaran Gagal", message: "Username sudah digunakan. Silakan gunakan username lain.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // Jika data pengguna belum ada, simpan data ke UserDefaults
            userDefaults.set(firstName, forKey: "firstName")
            userDefaults.set(lastName, forKey: "lastName")
            userDefaults.set(userName, forKey: "userName")
            userDefaults.set(email, forKey: "email")
            userDefaults.set(phone, forKey: "phone")
            userDefaults.set(password, forKey: "password")
            userDefaults.synchronize()
            
            // Reset TextField
            firstNameTf.text = ""
            lastNameTf.text = ""
            userNameTf.text = ""
            emailTf.text = ""
            phoneTf.text = ""
            passwordTf.text = ""
            
            // Tampilkan pesan keberhasilan menggunakan UIAlertController
            let alertController = UIAlertController(title: "Pendaftaran Berhasil", message: "Akun berhasil dibuat!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                // Print data yang sudah ditambahkan ke UserDefaults
                self.printUserData()
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func printUserData() {
        // Ambil data dari UserDefaults
        let userDefaults = UserDefaults.standard
        if let firstName = userDefaults.string(forKey: "firstName"),
           let lastName = userDefaults.string(forKey: "lastName"),
           let userName = userDefaults.string(forKey: "userName"),
           let email = userDefaults.string(forKey: "email"),
           let phone = userDefaults.string(forKey: "phone"),
           let password = userDefaults.string(forKey: "password") {
            // Cetak data ke konsol
            print("Data yang ditambahkan ke UserDefaults:")
            print("First Name: \(firstName)")
            print("Last Name: \(lastName)")
            print("Username: \(userName)")
            print("Email: \(email)")
            print("Phone: \(phone)")
            print("Password: \(password)")
        }
    }
}


