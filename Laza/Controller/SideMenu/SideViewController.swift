//
//  SideViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 02/08/23.
//

import UIKit

class SideViewController: UIViewController {
    @IBAction func sideBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var userName: UILabel!
    @IBAction func switchBtn(_ sender: Any) {
        if let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first {
            if (sender as AnyObject).isOn {
                window.overrideUserInterfaceStyle = .dark
                return
            }
            window.overrideUserInterfaceStyle =  .light
            return
        }
    }
    // view order
    @IBOutlet weak var viewOrder: UIView!
    // view Button
    @IBOutlet weak var viewButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // view order
        viewOrder.layer.cornerRadius = 8
        viewOrder.layer.masksToBounds = true
        // view Button
        viewButton.layer.cornerRadius = viewButton.bounds.height / 2
        viewButton.layer.masksToBounds = true
    }
    
    
}
