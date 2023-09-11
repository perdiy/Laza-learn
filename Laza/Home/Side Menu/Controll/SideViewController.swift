//
//  SideViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 02/08/23.
//

import UIKit

protocol protocolTabBarDelegate: AnyObject {
  func protocolGoToWishlist()
  func protocolGoToCart()
  func protocolGoToProfile()
  func protocolGoToChangePassword()
}


class SideViewController: UIViewController {
    
    weak var delegate: protocolTabBarDelegate?
    
     // Outlet untuk elemen-elemen tampilan
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var passwordButtonNav: UIButton!
    
    // ViewModel untuk profil pengguna
    let userProfileViewModel = UserProfileViewModel()
    
    // Tombol untuk membuka tampilan keranjang
    @IBAction func cartBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? TabBarViewController {
            navigationController?.pushViewController(cartViewController, animated: true)
        }
    }
    
    // Tombol untuk membuka tampilan perubahan kata sandi
    @IBAction func passwordButtonNavTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChangePassViewController") as? ChangePassViewController {
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    @IBAction func whistlistBtn(_ sender: Any) {
        let performMyTabBar = UIStoryboard(name: "TabBar", bundle: nil)
                let tabbar: UITabBarController = performMyTabBar.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                tabbar.selectedIndex = 1
                self.navigationController?.pushViewController(tabbar, animated: true)
    }
    
    @IBAction func cartB(_ sender: Any) {
        let performMyTabBar = UIStoryboard(name: "TabBar", bundle: nil)
                let tabbar: UITabBarController = performMyTabBar.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                tabbar.selectedIndex = 2
                self.navigationController?.pushViewController(tabbar, animated: true)
    }
    
    @IBAction func profilebtn(_ sender: Any) {
        let performMyTabBar = UIStoryboard(name: "TabBar", bundle: nil)
                let tabbar: UITabBarController = performMyTabBar.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                tabbar.selectedIndex = 3
                self.navigationController?.pushViewController(tabbar, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mengatur sudut lengkungan untuk latar belakang
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Memeriksa dan memperbarui token akses jika diperlukan
        ApiCallRefreshToken().refreshTokenIfNeeded { [weak self] in
            self?.loadUserProfile()
        } onError: { errorMessage in
            print(errorMessage)
        }
        
        // Mengatur sudut lengkungan untuk gambar profil
        imgView.layer.cornerRadius = imgView.frame.width / 2
        imgView.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
    }
    // Tombol untuk menutup tampilan samping
    @IBAction func sideBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // Tombol untuk mengganti tema tampilan
    @IBAction func switchBtn(_ sender: UISwitch) {
        if sender.isOn {
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                   let appDelegate = windowScene.windows.first
                   appDelegate?.overrideUserInterfaceStyle = .dark
               }
               UserDefaults.standard.setValue(true, forKey: "darkmode")
           } else {
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                   let appDelegate = windowScene.windows.first
                   appDelegate?.overrideUserInterfaceStyle = .light
               }
               UserDefaults.standard.setValue(false, forKey: "darkmode")
           }
       }
     
    // Tombol untuk logout pengguna
    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Konfirmasi Logout", message: "Anda yakin ingin logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "iya", style: .default, handler: { [weak self] _ in
            self?.performLogout()
        }))
        alert.addAction(UIAlertAction(title: "tidak", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Melakukan proses logout pengguna
    func performLogout() {
            userProfileViewModel.logout { [weak self] error in
                if let error = error {
                    print("Logout error: \(error.localizedDescription)")
                } else {
                    print("Logout berhasil")
                    if let welcomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                        self?.navigationController?.pushViewController(welcomeViewController, animated: true)
                    }
                }
            }
        }
    
    // Memuat profil pengguna
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
    func checkDarkMode() {
            let isDarkMode = UserDefaults.standard.bool(forKey: "darkmode")
            if isDarkMode {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let appDelegate = windowScene.windows.first
                    appDelegate?.overrideUserInterfaceStyle = .dark
                }
                switchBtn.isOn = true
            } else {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let appDelegate = windowScene.windows.first
                    appDelegate?.overrideUserInterfaceStyle = .light
                }
                switchBtn.isOn = false
            }
        }
}
