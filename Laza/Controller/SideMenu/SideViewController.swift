//
//  SideViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 02/08/23.
//

import UIKit

class SideViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    let userProfileViewModel = UserProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user profile information from API
        loadUserProfile()
        
        // Konfigurasi tampilan view order
        let viewOrder = self.view.viewWithTag(1)
        viewOrder?.layer.cornerRadius = 8
        viewOrder?.layer.masksToBounds = true
        
        // Konfigurasi tampilan view Button
        let viewButton = self.view.viewWithTag(2)
        viewButton?.layer.cornerRadius = viewButton?.bounds.height ?? 0 / 2
        viewButton?.layer.masksToBounds = true
    }

    @IBAction func sideBtn(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func switchBtn(_ sender: UISwitch) {
        if let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first {
            if sender.isOn {
                window.overrideUserInterfaceStyle = .dark
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

    @IBAction func logoutButton(_ sender: Any) {
        userProfileViewModel.logoutUser { [weak self] error in
            if let error = error {
                print("Error logging out user: \(error)")
            } else {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
                    if let loginViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                        self?.navigationController?.pushViewController(loginViewController, animated: true)
                    }
                }
            }
        }
    }

    func loadUserProfile() {
        userProfileViewModel.loadUserProfile { [weak self] error in
            if let error = error {
                print("Error loading user profile: \(error)")
            } else {
                DispatchQueue.main.async {
                    self?.userName.text = self?.userProfileViewModel.username
                }
            }
        }
    }
}
