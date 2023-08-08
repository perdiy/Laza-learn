//
//  SideViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 02/08/23.
//

import UIKit

class SideViewController: UIViewController {
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
