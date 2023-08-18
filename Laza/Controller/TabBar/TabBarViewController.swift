//
//  TabBarViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
// 

import UIKit

class TabBarViewController: UITabBarController {
    var userToken: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        if let token = userToken {
                   // You can use this token to make API requests
                   print("User Token in MyProfileViewController: \(token)")
               }
    }
    


}
