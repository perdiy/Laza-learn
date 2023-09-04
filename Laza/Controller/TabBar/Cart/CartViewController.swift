//
//  CartViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit
import SnackBar

class CartViewController: UIViewController {
    
    var cartProducts: [ProductCart] = []
    var selectedAddress: DataAllAddress?
    var cartViewModel = CartViewModel()
    var allSize: AllSize?
    var cartModel: CartProduct?
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var shippingCost: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mendaftarkan sel kustom
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
        setupTabBarItemImage()
        tableView.dataSource = self
        tableView.reloadData()
        getSizeAll()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCartProducts()
        fetchAddresses()
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
    
    @IBAction func paymentBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
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
    
    // MARK: - Fetch Addresses
    func fetchAddresses() {
        // Mengambil token dari Keychain
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            return
        }
        
        cartViewModel.fetchAddresses { [weak self] addresses in
            if let addresses = addresses, let primaryAddress = addresses.first(where: { $0.isPrimary == true }) {
                DispatchQueue.main.async {
                    self?.countryLabel.text = primaryAddress.country
                    self?.cityLabel.text = primaryAddress.city
                }
            }
        }
    }
    
    
    // Fungsi untuk mengambil produk di keranjang
    func fetchCartProducts() {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("Token pengguna tidak tersedia.")
            return
        }
        cartViewModel.getProducInCart(accessTokenKey: token) { [weak self] cartProductData in
            self?.cartProducts = cartProductData.data.products ?? []
            let orderInfo = cartProductData.data.orderInfo
            DispatchQueue.main.async {
                self?.total.text = "$ \(orderInfo!.total)"
                self?.shippingCost.text = "$ \(orderInfo!.shippingCost)"
                self?.subTotal.text = "$ \(orderInfo!.subTotal)"
                self?.tableView.reloadData()
            }
        }
    }
    
    
    func getSizeAll(){
        cartViewModel.getSizeAll { allSize in
            DispatchQueue.main.async { [weak self] in
                self?.allSize = allSize
                print(allSize, "ini adalah data all size")
            }
        }
    }
    
    func getSizeId(forSize size: String) -> Int{
        var sizedId = -1
        guard let allSizeData = allSize?.data else { return sizedId }
        print("size", allSizeData)
        for index in 0..<allSizeData.count {
            if allSizeData[index].size == size {
                sizedId = allSizeData[index].id
                break
            }
        }
        return sizedId
    }
    
}
// Mengimplementasikan metode sumber data untuk tabel
extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.delegate = self
        // Mengambil produk di keranjang untuk baris saat ini
        let cartProduct = cartProducts[indexPath.row]
        // Mengisi sel dengan data produk di keranjang
        cell.productLabel.text = cartProduct.productName
        cell.priceLabel.text = "$ \(cartProduct.price)"
        cell.imgView.loadImageFromURL(url: cartProduct.imageURL)
        cell.jumlahLabel.text = "\(cartProduct.quantity)"
        cell.sizeProductLabel.text = "Size \(cartProduct.size)"
        
        return cell
    }
    
    
}

// Mengimplementasikan protokol CartTableViewCellDelegate
extension CartViewController: CartTableViewCellDelegate {
    // kurangi product item
    func cartCellDidTapDecrease(cell: CartTableViewCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let cartProduct = cartProducts[indexPath.row]
        let sizeId = getSizeId(forSize: cartProduct.size)
        cartViewModel.decreaseCartItemQuantity(productId: cartProduct.id, sizedId: sizeId) {
            self.fetchCartProducts()
            completion(cartProduct.quantity - 1)
        }
    }
    // tambah product item
    func cartCellDidTapIncrease(cell: CartTableViewCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let cartProduct = cartProducts[indexPath.row]
        let sizeId = getSizeId(forSize: cartProduct.size)
        cartViewModel.addCartItemQuantity(productId: cartProduct.id, sizedId: sizeId) {
            self.fetchCartProducts()
            completion(cartProduct.quantity + 1)
        }
    }
    
    func updateCountProduct(cell: CartTableViewCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let cartData = cartModel?.data.products![indexPath.row] {
            completion(cartData.quantity)
        }
    }
    
    // delete Item
    func cartCellDidTapDelete(_ cell: CartTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let cartProduct = cartProducts[indexPath.row]
        let sizedId = getSizeId(forSize: cartProduct.size)
        
        cartViewModel.deleteCartItem(productId: cartProduct.id, sizedId: sizedId) {
            self.fetchCartProducts()
            print("Item deleted successfully")
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.cartProducts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
                
                SnackBar.make(in: self.view, message: "Item Delete success", duration: .lengthLong).show()
            }
        }
    }
}

