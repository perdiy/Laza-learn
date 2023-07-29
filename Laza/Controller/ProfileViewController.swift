//
//  ProfileViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!

    @IBAction func updatePasswordBtn(_ sender: Any) {
        showUpdatePasswordAlert()
    }

    @IBAction func logoutBtn(_ sender: Any) {
        logout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        showUserData()
    }

    func showUserData() {
        if let username = UserDefaults.standard.string(forKey: "username") {
            nameLabel.text = "Username: \(username)"
        }

        if let password = UserDefaults.standard.string(forKey: "password") {
            let maskedPassword = String(repeating: "*", count: password.count)
            passwordLabel.text = "Password: \(maskedPassword)"
        }
    }

    func showUpdatePasswordAlert() {
        let alert = UIAlertController(title: "Update Password", message: "Enter your new password", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Current Password"
            textField.isSecureTextEntry = true
        }

        alert.addTextField { textField in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let currentPassword = alert.textFields?.first?.text,
               let newPassword = alert.textFields?.last?.text {

                // Periksa kata sandi saat ini cocok dengan yang disimpan di UserDefaults
                if let storedPassword = UserDefaults.standard.string(forKey: "password"),
                   storedPassword == currentPassword {

                    // Simpan kata sandi baru ke UserDefaults
                    UserDefaults.standard.set(newPassword, forKey: "password")
                    self.showUserData()
                } else {
                    self.showAlert(title: "Error", message: "Incorrect current password.")
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func logout() {
        // Clear user defaults
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        navigateToWelcomeViewController()
    }

    func navigateToWelcomeViewController() {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationItem.hidesBackButton = true
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
