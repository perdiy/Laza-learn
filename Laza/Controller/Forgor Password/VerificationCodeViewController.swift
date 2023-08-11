//
//  VerificationCodeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class VerificationCodeViewController: UIViewController {
    
    var email: String?
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var codeTextField: UITextField! {
        didSet {
            codeTextField.addShadow(color: .gray, widht: 0.5, text: codeTextField)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        if let email = email {
            print("Received email: \(email)")
        }
    }
    
    @IBAction func verifyCodeBtn(_ sender: Any) {
        if let newPasswordVC = storyboard?.instantiateViewController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController {
            navigationController?.pushViewController(newPasswordVC, animated: true)
        }
    }
}
