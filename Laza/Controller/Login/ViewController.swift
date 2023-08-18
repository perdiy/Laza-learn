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
        checkLoggedIn()
    }
    
    private func checkLoggedIn() {
            if let userToken = UserDefaults.standard.string(forKey: "userToken") {
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                if let myProfileVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                    myProfileVC.userToken = userToken
                    
                    navigationController?.pushViewController(myProfileVC, animated: false)
                }
            }
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

