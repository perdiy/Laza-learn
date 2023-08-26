//
//  ViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 26/07/23.
//

import UIKit
import GoogleSignIn


class ViewController: UIViewController {
    
    // Google Button sign in with Google
    @IBAction func googleBtn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            print("Sign in success: \(String(describing: signInResult.user.profile?.email))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedIn()
    }
    
    // cek sudah login atau belum dengan user token
    private func checkLoggedIn() {
        if let userToken = UserDefaults.standard.string(forKey: "userToken") {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            if let myProfileVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                myProfileVC.userToken = userToken
                
                navigationController?.pushViewController(myProfileVC, animated: false)
            }
        }
    }
    
    // Sign Up Button
    @IBAction func SignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    // Sign In Button
    @IBAction func SignInButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
}

