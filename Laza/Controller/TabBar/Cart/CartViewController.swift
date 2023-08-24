//
//  CartViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class CartViewController: UIViewController {
    
    var cartProducts: [ProductCart] = []
    var cartViewModel = CartViewModel() // Assuming you have created CartViewModel
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        setupTabBarItemImage()
        tableView.dataSource = self

        fetchCartProducts()
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
    
    @IBAction func paymentBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentMethodeViewController") as? PaymentMethodeViewController {
            navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    @IBAction func addressBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "ListAddressViewController") as? ListAddressViewController {
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
    
    @IBAction func CheckoutBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "OrderConfimed", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "OrderConfirmedViewController") as? OrderConfirmedViewController {
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
    
    // Function to fetch cart products
    func fetchCartProducts() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("User token not available.")
            return
        }
        
        cartViewModel.getProducInCart(accessTokenKey: token) { [weak self] cartProductData in
            self?.cartProducts = cartProductData.data.products ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        let cartProduct = cartProducts[indexPath.row]
    
        cell.productLabel.text = cartProduct.productName
        cell.priceLabel.text = "$ \(cartProduct.price)"
        cell.imgView.loadImageFromURL(url: cartProduct.imageURL)
        return cell
    }
}
