//
//  MyProfileViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import UIKit

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditProfileDelegate {
    
    @IBAction func editProfileBtn(_ sender: Any) {
        navigateToEditProfile() // Memanggil method untuk menavigasi ke halaman edit profil
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    var viewModel: MyProfileViewModel! // ViewModel untuk mengelola data profil
    var userData: DataClass? // Data profil pengguna
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mengatur tampilan gambar profil
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        
        // Inisialisasi viewModel untuk mengelola profil
        viewModel = MyProfileViewModel()
        viewModel.delegate = self
        viewModel.loadUserProfile() // Memuat profil pengguna saat tampilan dimuat
        setupTabBarItemImage()
    }
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Profile"
        label.textColor = UIColor(named: "PurpleButton")
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // [weak self] Ini akan membantu menghindari potensi masalah seperti strong reference cycle.
        // Memeriksa dan memperbarui token akses jika diperlukan
        ApiCallRefreshToken().refreshTokenIfNeeded { [weak self] in
            self?.viewModel.loadUserProfile()
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    
    @IBAction func buttonAddImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Mendapatkan gambar yang dipilih oleh pengguna
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil) // Menutup pemilih gambar
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) // Menutup pemilih gambar jika dibatalkan
    }
    
    // Navigasi ke halaman edit profil
    private func navigateToEditProfile() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let editProfileViewController = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            editProfileViewController.userData = userData
            editProfileViewController.delegate = self
            navigationController?.pushViewController(editProfileViewController, animated: true)
        }
    }
    
    // Implementasi EditProfileDelegate untuk mendeteksi pembaruan profil
    func profileUpdated() {
        viewModel.loadUserProfile()
    }
    
    // Mendapatkan dan menampilkan gambar profil pengguna dari URL
    func displayProfileImage(_ imageURL: String) {
        imageView.loadImageFromURL(url: imageURL)
    }
}

// Implementasi MyProfileViewModelDelegate untuk menampilkan data profil
extension MyProfileViewController: MyProfileViewModelDelegate {
    func updateUserProfile(_ userData: DataClass) {
        DispatchQueue.main.async {
            self.usernameLabel.text = "\(userData.username)"
            self.emailLabel.text = "\(userData.email)"
            self.fullnameLabel.text = "\(userData.fullName)"
            self.userData = userData
            self.displayProfileImage(userData.imageUrl ?? "")
        }
    }
}
