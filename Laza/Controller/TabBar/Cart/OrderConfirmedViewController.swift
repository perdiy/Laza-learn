//
//  OrderConfirmedViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class OrderConfirmedViewController: UIViewController {
    
    // viewback
    @IBOutlet weak var backView: UIView!
    
    // back button
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = backView.bounds.height / 2.0
        backView.clipsToBounds = true
        
    }
    
}
