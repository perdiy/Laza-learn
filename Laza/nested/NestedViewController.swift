//
//  NestedViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit
import SideMenu

class NestedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    @IBOutlet weak var tableView: UITableView!
    var categories: [String] = []
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sideMenu
        menu = SideMenuNavigationController(rootViewController: UIViewController())
        
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
    }
    
    //SideMenu
    
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
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
        
        task.resume()
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
            return products.count
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
            cell.configure(data: products)
            cell.delegateProductProtocol = self
            return cell
        }
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
