//
//  SideViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 02/08/23.
//

import UIKit

class SideViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var passwordButtonNav: UIButton!
    let userProfileViewModel = UserProfileViewModel()
    @IBAction func cartBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? TabBarViewController {
            navigationController?.pushViewController(cartViewController, animated: true)
        }
    }
    @IBAction func passwordButtonNavTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChangePassViewController") as? ChangePassViewController {
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        loadUserProfile()
        imgView.layer.cornerRadius = imgView.frame.width / 2
        imgView.layer.masksToBounds = true
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
        let alert = UIAlertController(title: "Konfirmasi Logout", message: "Anda yakin ingin logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "iya", style: .default, handler: { [weak self] _ in
            self?.performLogout()
        }))
        alert.addAction(UIAlertAction(title: "tidak", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func performLogout() {
        userProfileViewModel.logout { [weak self] error in
            if let error = error {
                print("Logout error: \(error.localizedDescription)")
            } else {
                print("Logout berhasil")
                if let welcomeViewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                    self?.navigationController?.pushViewController(welcomeViewController, animated: true)
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
                    if let imageUrl = self?.userProfileViewModel.imageUrl {
                        self?.imgView.loadImageFromURL(url: imageUrl)
                    }
                }
            }
        }
    }
}
