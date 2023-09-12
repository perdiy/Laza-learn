//
//  NestedViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit
import SideMenu
import SnackBar

class NestedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var menu: SideMenuNavigationController?
    // Variabel untuk menyimpan objek SideMenuNavigationController yang digunakan untuk tampilan menu samping.

    var isValidToken = false
    // Variabel yang digunakan untuk mengindikasikan apakah token yang digunakan oleh pengguna valid atau tidak.

    var categories : Brand?
    // Variabel untuk menyimpan data kategori produk (Brand) yang diperoleh dari API.

    var products: [DatumProdct] = []
    // Variabel untuk menyimpan daftar produk (DatumProdct) yang diperoleh dari API.

    var filteredProducts: [DatumProdct] = []
    // Variabel untuk menyimpan daftar produk yang telah difilter berdasarkan pencarian pengguna.

    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var viewCart: UIView! {
        didSet {
            viewCart.layer.cornerRadius = viewCart.bounds.height / 2
            viewCart.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var viewSide: UIView! {
        didSet {
            viewSide.layer.cornerRadius = viewSide.bounds.height / 2
            viewSide.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var viewUngu: UIView! {
        didSet {
            viewUngu.layer.cornerRadius = 8
            viewUngu.layer.masksToBounds = true
        }
    }
    
    @IBAction func sideButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "SideMenuNavigationController", sender: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellCategoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        self.tableView.register(cellCategoryNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        let cellProNib = UINib(nibName: "ProTableViewCell", bundle: nil)
        self.tableView.register(cellProNib, forCellReuseIdentifier: "ProTableViewCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = true
        
        setupTabBarItemImage()
        
        fetchCategories()
        fetchProducts()
        
        search.delegate = self
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Home"
        label.textColor = UIColor(named: "PurpleButton")
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
    // Fungsi untuk meng-handle perubahan teks pada pencarian
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                return product.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    // Fungsi untuk meng-handle tombol pembatalan pencarian
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.text = ""
        filteredProducts = products
        tableView.reloadData()
    }
    
    // Menghitung jumlah bagian (sections) dalam tabel
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Menghitung jumlah baris dalam setiap bagian (section) tabel
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    // Mengatur sel (cell) yang akan ditampilkan dalam tabel
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Bagian pertama berisi kategori
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.delegate = self
            cell.configure(data: categories?.description ?? [])
            return cell
        } else {
            // Bagian kedua berisi produk
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProTableViewCell", for: indexPath) as! ProTableViewCell
            cell.configure(data: filteredProducts)
            cell.delegateProductProtocol = self
            return cell
        }
    }
    
    // Mengambil data kategori dari model
    func fetchCategories() {
        NestedModel.shared.fetchCategories { [weak self] (brand) in
            self?.categories = brand
            self?.tableView.reloadData()
        }
    }
    
    // Mengambil data produk dari model
    func fetchProducts() {
        NestedModel.shared.fetchProducts { [weak self] (products) in
            self?.products = products
            self?.filteredProducts = products
            self?.tableView.reloadData()
        }
    }
}

// Fungsi untuk menavigasi ke layar produk all
extension NestedViewController: ProductCellProtocol {
    // Pindah ke layar produk semua dengan mengirim data all produk
    func goToAllProduct(productAll: [DatumProdct]) {
        if let prodAllVC = UIStoryboard(name: "ProductAll", bundle: nil).instantiateViewController(withIdentifier: "ProductAllViewController") as? ProductAllViewController {
            prodAllVC.allProducts = products
            prodAllVC.navigationItem.hidesBackButton = true
            navigationController?.pushViewController(prodAllVC, animated: true)
        }
        
    }
    
    // Fungsi untuk menavigasi ke layar detail produk
    func goToDetailProduct(product: DatumProdct) {
        // Pindah ke layar detail produk dengan mengirim ID produk
        if let detailProVC = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailProVC.productId = product.id
            detailProVC.navigationItem.hidesBackButton = true
            navigationController?.pushViewController(detailProVC, animated: true)
        }
    }
}

extension NestedViewController: navigateToDetailBrand {
    // Fungsi untuk menavigasi ke layar merek semua (brand all)
    func goToViewAllBrand(names: [String], logoURLs: [String]) {
        // Pindah ke layar merek semua dengan mengirim daftar nama merek dan URL logo
        let storyboard = UIStoryboard(name: "BrandAll", bundle: nil)
        if let brandAllVC = storyboard.instantiateViewController(withIdentifier: "BrandAllViewController") as? BrandAllViewController {
            brandAllVC.receivedNames = names
            brandAllVC.receivedLogoURLs = logoURLs
            navigationController?.pushViewController(brandAllVC, animated: true)
        }
    }
    
    // Fungsi untuk menavigasi ke layar detail merek (brand)
    func goToDetailBrand(branName: String, brandLogoUrl: String) {
        // Pindah ke layar produk merek (brand) dengan mengirim nama merek dan URL logo
        guard let productByBrandVC = UIStoryboard(name: "ProductByBrand", bundle: nil).instantiateViewController(withIdentifier: "prductByBrandViewController") as? prductByBrandViewController else {return}
        productByBrandVC.brandName = branName
        productByBrandVC.imgUrl = brandLogoUrl
        productByBrandVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(productByBrandVC, animated: true)
        
    }
    
}

