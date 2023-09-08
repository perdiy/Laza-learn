//
//  OrderConfirmedViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit
import SnackBar

protocol checkoutProtocol: AnyObject {
    func goTohome()
    func goToCart()
}

class OrderConfirmedViewController: UIViewController {
    
    weak var delegate: checkoutProtocol?
    
    @IBOutlet weak var backView: UIView!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goToorderBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continurBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.goTohome()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SnackBar.make(in: self.view, message: "Berhasil CheckOut", duration: .lengthLong).show()
        backView.layer.cornerRadius = backView.bounds.height / 2.0
        backView.clipsToBounds = true
        
    }
    
}
