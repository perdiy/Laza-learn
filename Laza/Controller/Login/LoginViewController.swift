//
//  LoginViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 26/07/23.
//

import UIKit

class LoginViewController: UIViewController {

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
    @IBAction func createBtn(_ sender: Any) {

        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    @IBAction func signInBtn(_ sender: Any) {
     
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
        
    
}
 
