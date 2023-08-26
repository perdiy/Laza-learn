//
//  CartViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class CartViewController: UIViewController {
    
    // Array untuk menyimpan produk di keranjang
    var cartProducts: [ProductCart] = []
    
    // ViewModel untuk operasi keranjang
    var cartViewModel = CartViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mendaftarkan sel kustom
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
        // Mengonfigurasi penampilan elemen tab bar
        setupTabBarItemImage()
        
        // Mengatur delegasi sumber data
        tableView.dataSource = self
        
        // Mengambil produk di keranjang dari server
        fetchCartProducts()
    }
    
    // Fungsi untuk mengatur penampilan elemen tab bar
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Keranjang"
        label.textColor = UIColor(named: "PurpleButton")
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
    // Aksi tombol
    @IBAction func paymentBtn(_ sender: Any) {
        // Pindah ke tampilan metode pembayaran
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentMethodeViewController") as? PaymentMethodeViewController {
            navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    @IBAction func addressBtn(_ sender: Any) {
        // Pindah ke tampilan daftar alamat
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "ListAddressViewController") as? ListAddressViewController {
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
    
    @IBAction func CheckoutBtn(_ sender: Any) {
        // Pindah ke tampilan konfirmasi pesanan
        let storyboard = UIStoryboard(name: "OrderConfimed", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "OrderConfirmedViewController") as? OrderConfirmedViewController {
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
    
    // Fungsi untuk mengambil produk di keranjang
    func fetchCartProducts() {
        // Periksa apakah token pengguna tersedia
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("Token pengguna tidak tersedia.")
            return
        }
        
        // Mengambil produk di keranjang menggunakan ViewModel
        cartViewModel.getProducInCart(accessTokenKey: token) { [weak self] cartProductData in
            self?.cartProducts = cartProductData.data.products ?? []
            
            // Memuat ulang tabel di utas utama
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// Mengimplementasikan metode sumber data untuk tabel
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        // Mengambil produk di keranjang untuk baris saat ini
        let cartProduct = cartProducts[indexPath.row]
        
        // Mengisi sel dengan data produk di keranjang
        cell.productLabel.text = cartProduct.productName
        cell.priceLabel.text = "$ \(cartProduct.price)"
        cell.imgView.loadImageFromURL(url: cartProduct.imageURL)
        return cell
    }
}
