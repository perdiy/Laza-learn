//
//  VerificationCodeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class VerificationCodeViewController: UIViewController {
    
    var email: String?
    
    @IBOutlet weak var codeTextField: UITextField! {
        didSet {
            codeTextField.addShadow(color: .gray, widht: 0.5, text: codeTextField)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = email {
            print("Received email: \(email)")
            
        }
    }
    
    @IBAction func verifyCodeBtn(_ sender: Any) {
        
    }
}
