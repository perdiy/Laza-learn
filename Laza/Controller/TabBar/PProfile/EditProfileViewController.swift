//
//  EditProfileViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 21/08/23.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func profileUpdated()
}

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var fullNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    
    var userData: DataClass?
    
    weak var delegate: EditProfileDelegate?
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonChangeProfile(_ sender: Any) {
        updateProfile()
    }
    
    @IBAction func buttonChangeImgProfile(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgUser.layer.cornerRadius = imgUser.frame.width / 2
        imgUser.layer.masksToBounds = true
        imgUser.contentMode = .scaleToFill
        
        if let userData = userData {
            userNameTf.text = userData.username
            fullNameTf.text = userData.fullName
            emailTf.text = userData.email
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imgUser.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            imgUser.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func updateProfile() {
        guard let newFullName = fullNameTf.text,
              let newUsername = userNameTf.text,
              let newEmail = emailTf.text,
              let newImage = imgUser.image else {
            return
        }

        ProfileService.shared.updateProfile(fullName: newFullName, username: newUsername, email: newEmail, image: newImage) { [weak self] success in
            if success {
                print("Profile updated successfully!")
                DispatchQueue.main.async {
                    self?.delegate?.profileUpdated()
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Failed to update profile")
                
                // Show an alert for failure
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Profile Update Failed", message: "An error occurred while updating your profile.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
