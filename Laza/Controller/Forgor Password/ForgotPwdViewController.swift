//
//  ForgotPwdViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class ForgotPwdViewController: UIViewController {

    @IBOutlet weak var emailTf: UITextField! {
        didSet{
            emailTf.addShadow(color: .gray, widht: 0.5, text: emailTf)
        }
    }
    @IBAction func forgotPasswordBtn(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}
