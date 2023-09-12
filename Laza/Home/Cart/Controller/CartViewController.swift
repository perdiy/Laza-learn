//
//  CartViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit
import SnackBar

class CartViewController: UIViewController {
    
    // Variabel untuk menyimpan data keranjang
    var cartProducts: [ProductCart] = []
    var selectedAddress: DataAllAddress?
    var cartViewModel = CartViewModel()
    var allSize: AllSize?
    var cartModel: CartProduct?
    var chooseCard: String = ""
    var selectedAdd: String = ""
    var selectedCount: String = ""
    var addressId: Int = 0
    var productId: Int = 0
    var prodIndexpath: IndexPath?
    var resultsProductOrder = [DataProduct]()
    var cartArrayModel = [ProductCart]()
    
    // Outlet untuk elemen UI
    @IBOutlet weak var numCardLb: UILabel!
    @IBOutlet weak var nameBankLb: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var shippingCost: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mendaftarkan sel kustom
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
        setupTabBarItemImage()
        tableView.dataSource = self
        tableView.reloadData()
        // Mengambil data ukuran produk
        getSizeAll()
        
        emptyLb.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Memuat produk dari keranjang saat tampilan akan muncul
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
    
    // Handler tombol pembayaran
    @IBAction func paymentBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
            paymentVC.delegate = self
            navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    // Handler tombol alamat
    @IBAction func addressBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "ListAddressViewController") as? ListAddressViewController {
            orderConfirmedVC.delegate = self
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
    
    // Handler tombol Checkout
    @IBAction func CheckoutBtn(_ sender: Any) {
        postOrder()
    }
    
    // Fungsi untuk mengeksekusi checkout
    func  CheckoutBtn(){
        let storyboard = UIStoryboard(name: "OrderConfimed", bundle: nil)
        if let orderConfirmedVC = storyboard.instantiateViewController(withIdentifier: "OrderConfirmedViewController") as? OrderConfirmedViewController {
            orderConfirmedVC.delegate = self
            navigationController?.pushViewController(orderConfirmedVC, animated: true)
        }
    }
    
    func postOrder() {
        let productList = self.resultsProductOrder
        let addressId = self.addressId
        let bank = "BNI"
        print("Order Result All Cart: \(productList)")
        print("Order ID Address: \(addressId)")
        print("Order bank: \(bank)")
        
        // Memanggil fungsi untuk melakukan pemesanan
        cartViewModel.postOrder(product: productList, address_id: addressId, bank: bank)
        { result in
            switch result {
            case .success :
                DispatchQueue.main.async {
                    self.CheckoutBtn()
                }
                print("Sukses Checkout")
            case .failure(let error):
                self.cartViewModel.apiCarts = { status, data in
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: status, message: data)
                    }
                }
                print("Error fetching order user: \(error.localizedDescription)")
            }
        }
    }
    
    // Fungsi untuk mengambil produk di keranjang
    func fetchCartProducts() {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("Token pengguna tidak tersedia.")
            return
        }
        // [weak self] Ini akan membantu menghindari potensi masalah seperti strong reference cycle.
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
    
    // Fungsi untuk mengambil ukuran semua produk
    func getSizeAll(){
        cartViewModel.getSizeAll { allSize in
            DispatchQueue.main.async { [weak self] in
                self?.allSize = allSize
                print(allSize, "ini adalah data all size")
            }
        }
    }
    
    // Fungsi untuk mengambil ID ukuran berdasarkan nama ukuran
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
        if cartProducts.count == 0 {
            emptyLb.isHidden = false
        } else {
            emptyLb.isHidden = true
        }
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.delegate = self
        
        // Mengambil produk di keranjang
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
extension CartViewController: CartTableViewCellDelegate, chooseAddressProtocol{
    func didSelectAddress(country: String, city: String, addressId: Int) {
        countryLabel.text = country
        cityLabel.text = city
        self.addressId = addressId
        print("sudah ada city \(city)")
    }
    
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
    
    // Mengurangi jumlah item produk di keranjang
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

// Ekstensi untuk mengimplementasikan protokol checkoutProtocol
extension CartViewController : choosePaymentProtocol{
    func delegatCardPayment(cardNumber: String, bankName: String) {
        numCardLb.text = cardNumber
        nameBankLb.text = bankName
        print("Sudah ada delegate \(cardNumber)")
    }
}

extension CartViewController: checkoutProtocol {
    // Handler untuk menuju halaman utama
    func goTohome() {
        print("goToHome")
        self.tabBarController?.selectedIndex = 0
    }
    
    // Handler untuk menuju halaman keranjang
    func goToCart() {
        self.tabBarController?.selectedIndex = 2
    }
    
}
