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
        guard let userToken = UserDefaults.standard.string(forKey: "userToken"),
              let newFullName = fullNameTf.text,
              let newUsername = userNameTf.text,
              let newEmail = emailTf.text else {
            return
        }
        
        let apiUrl = URL(string: "https://lazaapp.shop/user/update")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData: [String: Any] = [
            "full_name": newFullName,
            "username": newUsername,
            "email": newEmail
            
        ]
         
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: updateData, options: [])
        } catch {
            print("Error serializing update data: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating profile: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Profile updated successfully!")
                    
                    DispatchQueue.main.async {
                        
                        
                        self.delegate?.profileUpdated()
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("Error updating profile: Status code \(httpResponse.statusCode)")
                    
                }
            }
        }.resume()
    }
}
