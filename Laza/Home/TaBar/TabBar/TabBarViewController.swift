//
//  TabBarViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit
import Security

class TabBarViewController: UITabBarController {
    var userToken: String?
    var userProfile: DataUseProfile? 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
       
    }
    
}


 
