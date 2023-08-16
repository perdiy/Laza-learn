//
//  MyProfileViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 16/08/23.
//

import UIKit

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    var viewModel: MyProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        
        viewModel = MyProfileViewModel()
        viewModel.delegate = self
        viewModel.loadUserProfile()
    }
    
    @IBAction func buttonAddImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MyProfileViewModelDelegate

extension MyProfileViewController: MyProfileViewModelDelegate {
    func updateUserProfile(_ userData: DataClass) {
        DispatchQueue.main.async {
            self.usernameLabel.text = "\(userData.username)"
            self.emailLabel.text = "\(userData.email)"
            self.fullnameLabel.text = "\(userData.fullName)"
        }
    }
}
