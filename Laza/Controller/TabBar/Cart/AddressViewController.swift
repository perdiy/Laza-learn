//
//  AddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class AddressViewController: UIViewController {
    // Back View
    @IBOutlet weak var backView: UIView!
    
  
    @IBAction func BackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // Back Button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = backView.bounds.height / 2.0
        backView.clipsToBounds = true
        
    }
    

}
