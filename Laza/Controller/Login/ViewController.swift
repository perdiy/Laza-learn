//
//  ViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 26/07/23.
//

import UIKit

class ViewController: UIViewController {
    
    // Button IB
    @IBAction func facebookBtn(_ sender: Any) {
    }
    
    @IBAction func twitterBtn(_ sender: Any) {
    }
    
    @IBAction func googleBtn(_ sender: Any) {
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    @IBAction func SignInButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
    
    
    
}

