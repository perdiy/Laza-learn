//
//  ViewController.swift
//  Lazaku
//
//  Created by Perdi Yansyah on 26/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewWhite: UIView! {
        didSet {
            // Atur border radius pada viewWhite
            viewWhite.layer.cornerRadius = 30
            viewWhite.layer.masksToBounds = true
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    @IBAction func skipBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "loginWith", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }

    @IBAction func womenBtn
    (_ sender: Any) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }

}




