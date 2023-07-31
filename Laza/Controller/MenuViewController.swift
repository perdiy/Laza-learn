//
//  MenuViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 31/07/23.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelectMenuItem(_ menuItem: String)
}

class MenuViewController: UIViewController {
    weak var delegate: MenuViewControllerDelegate?
    
    // Add menu items as per your requirement.
    let menuItems = ["Menu Item 1", "Menu Item 2", "Menu Item 3", "Logout"]
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUsernameLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUsernameLabel() // Update the username label when the view appears.
    }
    
    func updateUsernameLabel() {
        if let username = UserDefaults.standard.string(forKey: "username") {
            usernameLabel.text = "Hello, \(username)"
        } else {
            usernameLabel.text = "Hello, Guest"
        }
    }
    
    @IBAction func menuItemButtonTapped(_ sender: UIButton) {
        let selectedItem = menuItems[sender.tag]
        if selectedItem == "Logout" {
            // Handle Logout action
            logout()
        } else {
            delegate?.didSelectMenuItem(selectedItem)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func logout() {
        // Clear user data from UserDefaults and navigate back to LoginViewController
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        
        // Navigate back to LoginViewController
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            UIApplication.shared.windows.first?.rootViewController = loginVC
        }
    }
}
