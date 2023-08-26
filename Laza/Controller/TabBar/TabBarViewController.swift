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
        
        // Menyembunyikan tombol kembali di navigation bar
        navigationItem.hidesBackButton = true
        
        // Mengecek apakah token pengguna tersedia
        if let token = userToken {
            // Anda dapat menggunakan token ini untuk membuat permintaan API
            print("Token Pengguna di MyProfileViewController: \(token)")
        }
    }
}

