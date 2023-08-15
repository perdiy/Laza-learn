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
    
    var categories: [String] = []
    var products: [DatumProdct] = []
    var filteredProducts: [DatumProdct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SnackBar.make(in: self.view, message: "Anda Berhasil Login", duration: .lengthLong).show()
        
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.text = ""
        filteredProducts = products
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.configure(data: categories)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProTableViewCell", for: indexPath) as! ProTableViewCell
            cell.configure(data: filteredProducts)
            cell.delegateProductProtocol = self
            return cell
        }
    }
    
    func fetchCategories() {
        guard let url = URL(string: "https://lazaapp.shop/brand") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let brandResponse = try decoder.decode(Brand.self, from: data)
                let brandNames = brandResponse.description.map { $0.name }
                DispatchQueue.main.async {
                    self.categories = brandNames
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching categories: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func fetchProducts() {
        guard let url = URL(string: "https://lazaapp.shop/products") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let productResponse = try decoder.decode(Product.self, from: data)
                DispatchQueue.main.async {
                    self.products = productResponse.data
                    self.filteredProducts = productResponse.data
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
    func goToDetailProduct(product: DatumProdct) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.product = product
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
