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
    
    // Outlet untuk komponen UI
    @IBOutlet weak var search: UISearchBar!
    var menu: SideMenuNavigationController?
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
    
    // Variabel untuk menyimpan data kategori dan produk
    var categories: [String] = []
    var products: [Product] = []
    var filteredProducts: [Product] = []
    
    // Variabel untuk mengatur indikator loading circle
    var isLoading = false
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tampilkan pesan snackbar
        SnackBar.make(in: self.view, message: "Anda Berhasil Login", duration: .lengthLong).show()
        
        // Daftarkan xib sel-sel kategori dan produk
        let cellCategoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        self.tableView.register(cellCategoryNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        let cellProNib = UINib(nibName: "ProTableViewCell", bundle: nil)
        self.tableView.register(cellProNib, forCellReuseIdentifier: "ProTableViewCell")
        
        // Tentukan data source dan delegate untuk tabel
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = true
        
        setupTabBarItemImage()
        
        // Inisialisasi indikator pemuatan
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Ambil data kategori dan produk dari API
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
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                return product.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.text = ""
        filteredProducts = products
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    // Mengatur jumlah bagian (sections) dalam tabel
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Kita ingin menampilkan dua bagian: kategori dan daftar produk
    }
    
    // Mengatur jumlah baris dalam setiap bagian tabel
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Bagian pertama adalah kategori, hanya satu baris untuk sel kategori
        } else {
            return filteredProducts.count // Bagian kedua adalah produk, jumlah baris sesuai dengan jumlah produk yang difilter
        }
    }
    
    // Mengisi sel tabel dengan data yang sesuai
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Bagian kategori: Menggunakan sel CategoryTableViewCell untuk menampilkan kategori
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.configure(data: categories)
            return cell
        } else {
            // Bagian produk: Menggunakan sel ProTableViewCell untuk menampilkan produk
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProTableViewCell", for: indexPath) as! ProTableViewCell
            cell.configure(data: filteredProducts) // Mengisi data produk ke dalam sel produk
            cell.delegateProductProtocol = self // Mengatur delegat untuk menangani interaksi pada produk
            return cell
        }
    }
    
    // Ambil data kategori dari API
    func fetchCategories() {
        isLoading = true
        activityIndicator.startAnimating()
        
        if !categories.isEmpty {
            self.tableView.reloadData()
            isLoading = false
            activityIndicator.stopAnimating()
            return
        }
        
        // URL untuk mengambil data kategori dari API
        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                if let categories = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    DispatchQueue.main.async {
                        self.categories = categories
                        self.tableView.reloadData()
                        self.isLoading = false
                        self.activityIndicator.stopAnimating()
                    }
                }
            } catch {
                print("Error fetching categories: \(error.localizedDescription)")
                self.isLoading = false
                self.activityIndicator.stopAnimating()
            }
        }
        
        // Jalankan task pengambilan data
        task.resume()
    }
    
    // Ambil data produk dari API
    func fetchProducts() {
        isLoading = true
        activityIndicator.startAnimating()
        
        if !products.isEmpty {
            self.tableView.reloadData()
            isLoading = false
            activityIndicator.stopAnimating()
            return
        }
        
        // URL untuk mengambil data produk dari API
        guard let url = URL(string: "https://fakestoreapi.com/products") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self.products = products
                    self.filteredProducts = products
                    self.tableView.reloadData()
                    self.isLoading = false
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error fetching products: \(error.localizedDescription)")
                self.isLoading = false
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}

extension NestedViewController: ProductCellProtocol {
    func goToDetailProduct(product: Product) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.product = product
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
