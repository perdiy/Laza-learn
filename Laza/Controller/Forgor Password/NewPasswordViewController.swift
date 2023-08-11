//
//  NewPasswordViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/08/23.
//

import UIKit 

class NewPasswordViewController: UIViewController {
    // hide or no text password
    var iconClick = true
    
    @IBAction func hidePassword(_ sender: Any) {
        if iconClick {
            iconClick = true
            passwordTf.isSecureTextEntry = false
        } else {
            iconClick = false
            passwordTf.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    
    @IBAction func hideConfirmPassword(_ sender: Any) {
        if iconClick {
            iconClick = true
            confirmPasswordTf.isSecureTextEntry = false
        } else {
            iconClick = false
            confirmPasswordTf.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBOutlet weak var passwordTf: UITextField!{
        didSet {
            passwordTf.addShadow(color: .gray, widht: 0.5, text: passwordTf)
        }
    }
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            confirmPasswordTf.addShadow(color: .gray, widht: 0.5, text: confirmPasswordTf)
        }
    }
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
    }
    

}
