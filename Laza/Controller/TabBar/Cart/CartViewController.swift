//
//  CartViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class CartViewController: UIViewController {
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    
    // Placeholder data untuk demonstrasi
    let cartItems: [CartItem] = [
        CartItem(namaProduk: "Men's Tie-Dye T-Shirt Nike Sportswear", gambarProduk: UIImage(named: "IMG"), hargaProduk: 20.0),
        CartItem(namaProduk: "Men's Tie-Dye T-Shirt Nike Sportswear", gambarProduk: UIImage(named: "IMG"), hargaProduk: 30.0),
        CartItem(namaProduk: "Men's Tie-Dye T-Shirt Nike Sportswear", gambarProduk: UIImage(named: "IMG"), hargaProduk: 15.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
        setupTabBarItemImage()
        
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Cart"
        label.textColor = UIColor(named: "PurpleButton")
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    } 
    
    // payment Button
    @IBAction func paymentBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentMethodeViewController") as? PaymentMethodeViewController {
            navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    // Addres Button
    @IBAction func addressBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "ListAddressViewController") as? ListAddressViewController {
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
    
    // Button Checkout
    @IBAction func CheckoutBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "OrderConfimed", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "OrderConfirmedViewController") as? OrderConfirmedViewController {
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    // Data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        let item = cartItems[indexPath.row]
        
        cell.productLabel.text = item.namaProduk
        cell.imgView.image = item.gambarProduk
        cell.priceLabel.text = "\(item.hargaProduk)"
        
        return cell
    }
    
}

// Struktur data placeholder untuk item dalam keranjang
struct CartItem {
    let namaProduk: String
    let gambarProduk: UIImage?
    let hargaProduk: Double
}
