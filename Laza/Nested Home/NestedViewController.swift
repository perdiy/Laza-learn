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
    
    // search
    @IBOutlet weak var search: UISearchBar!
    
    // sideMenu
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
        // Show the menu
        performSegue(withIdentifier: "SideMenuNavigationController", sender: nil)
        //        present(menu!, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var categories: [String] = []
    var products: [Product] = []
    var filteredProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // snackBar
        SnackBar.make(in: self.view, message: "Anda Berhasil Login", duration: .lengthLong).show()
        // Daftarkan xib CategoryTableViewCell
        let cellCategoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        self.tableView.register(cellCategoryNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        // Daftarkan xib ProTableViewCell
        let cellProNib = UINib(nibName: "ProTableViewCell", bundle: nil)
        self.tableView.register(cellProNib, forCellReuseIdentifier: "ProTableViewCell")
        
        // Tentukan data source dan delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = true
        
        // Ambil data kategori dari API
        fetchCategories()
        // Ambil data produk dari API
        fetchProducts()
        
        // Setel delegat untuk search bar
        search.delegate = self
        
        setupTabBarItemImage()
    }
    
    // MARK: Setup BarItem when Clicked Change into Text
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
            // Jika teks pencarian kosong, tampilkan semua produk
            filteredProducts = products
        } else {
            // Filter produk berdasarkan teks pencarian
            filteredProducts = products.filter { product in
                return product.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Bersihkan search bar dan tampilkan semua produk
        search.text = ""
        filteredProducts = products
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Kembalikan jumlah baris untuk kategori dan produk
        if section == 0 {
            return 1
        } else {
            return filteredProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Buat sel-sel berbeda untuk kategori, produk, dan header
        if indexPath.section == 0 {
            // CategoryTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.configure(data: categories) // Setel data kategori ke CategoryTableViewCell
            return cell
        } else {
            // ProTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProTableViewCell", for: indexPath) as! ProTableViewCell
            cell.configure(data: filteredProducts)
            cell.delegateProductProtocol = self
            return cell
        }
    }
    
    // Ambil data kategori dari API
    func fetchCategories() {
        if !categories.isEmpty {
            self.tableView.reloadData()
            return
        }
        
        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                if let categories = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    DispatchQueue.main.async {
                        self.categories = categories
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error fetching categories: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // Ambil data produk dari API
    func fetchProducts() {
        if !products.isEmpty {
            self.tableView.reloadData()
            return
        }
        
        guard let url = URL(string: "https://fakestoreapi.com/products") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self.products = products
                    self.filteredProducts = products // Setel filteredProducts dengan semua produk awal
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching products: \(error.localizedDescription)")
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

