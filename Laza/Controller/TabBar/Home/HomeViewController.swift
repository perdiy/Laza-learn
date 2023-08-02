////
////  HomeViewController.swift
////  Laza
////
////  Created by Perdi Yansyah on 27/07/23.
////
//
//import UIKit
//import SideMenu
//
//class HomeViewController: UIViewController {
//    
//    // view
//    @IBOutlet weak var unguView: UIView! {
//        didSet {
//            unguView.layer.cornerRadius = 8
//            unguView.layer.masksToBounds = true
//        }
//    }
//    @IBOutlet weak var sideView: UIView!{
//        didSet {
//            sideView.layer.cornerRadius = sideView.bounds.height / 2
//            sideView.layer.masksToBounds = true
//        }
//    }
//    @IBOutlet weak var cartView: UIView!{
//        didSet {
//            cartView.layer.cornerRadius = cartView.bounds.height / 2
//            cartView.layer.masksToBounds = true
//        }
//    }
//    
//    // collection
//    @IBOutlet weak var BrandCollectionView: UICollectionView!
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    var products: [[String: Any]] = []
//    // Array untuk menyimpan enum Category
//    var categories: [Category] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.hidesBackButton = true
//        setupSideMenu()
//        fetchDataFromAPI()
//        fetchCategoriesFromAPI() // Memanggil fungsi untuk mengambil data enum Category
//        
//        // Set up  collection view delegate, datasource
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        BrandCollectionView.delegate = self
//        BrandCollectionView.dataSource = self
//        
//        // Register the custom cells
//        let productCellNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
//        collectionView.register(productCellNib, forCellWithReuseIdentifier: "ProductCollectionViewCell")
//        
//        let brandCellNib = UINib(nibName: "BrandCollectionViewCell", bundle: nil)
//        BrandCollectionView.register(brandCellNib, forCellWithReuseIdentifier: "BrandCollectionViewCell")
//    }
//    
//    func setupSideMenu() {
//        // Create a menu view controller
//        let menuViewController = UIStoryboard(name: "MenuSide", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//        
//        // Set the presentation style of the menu
//        SideMenuManager.default.leftMenuNavigationController = UISideMenuNavigationController(rootViewController: menuViewController)
//        SideMenuManager.default.leftMenuNavigationController?.presentationStyle = .menuSlideIn
//        SideMenuManager.default.menuFadeStatusBar = false
//        
//        // Set the width of the menu
//        SideMenuManager.default.menuWidth = UIScreen.main.bounds.width * 0.9
//        
//        // Add a gesture recognizer to open the menu when swiping from the left edge
//        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
//        
//        // Set the delegate of MenuViewController to handle menu item selection
//        menuViewController.delegate = self
//    }
//    
//    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
//        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
//    }
//    
//    // Apifetch
//    func fetchDataFromAPI() {
//        guard let url = URL(string: "https://fakestoreapi.com/products") else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            if let data = data {
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                    if let productsArray = jsonResponse as? [[String: Any]] {
//                        self.products = productsArray
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
//                    }
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }.resume()
//    }
//    
//    // Apifetch untuk enum Category
//    func fetchCategoriesFromAPI() {
//        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            if let data = data {
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                    if let categoriesArray = jsonResponse as? [String] {
//                        
//                        self.categories = categoriesArray.compactMap { Category(rawValue: $0) }
//                        DispatchQueue.main.async {
//                            self.BrandCollectionView.reloadData()
//                        }
//                    }
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }.resume()
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == BrandCollectionView {
//            return categories.count
//        }
//        // Jika ini adalah collectionView untuk produk, kembalikan jumlah produk
//        return products.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == BrandCollectionView {
//            let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCollectionViewCell", for: indexPath) as! BrandCollectionViewCell
//            
//            // Ambil data kategori dari array categories
//            let category = categories[indexPath.item]
//            
//            // Setel teks sel sesuai dengan kategori
//            brandCell.brandLabel.text = category.rawValue
//            
//            return brandCell
//        }
//        
//        // Jika ini adalah collectionView untuk produk, isi sel dengan data produk
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
//        
//        let product = products[indexPath.item]
//        if let title = product["title"] as? String,
//           let price = product["price"] as? Double,
//           let imageString = product["image"] as? String,
//           let imageUrl = URL(string: imageString) {
//            cell.titleLabel.text = title
//            cell.priceLabel.text = "$ \(price)"
//            
//            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
//                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        cell.productImageView.image = image
//                    }
//                }
//            }.resume()
//        }
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Jika ini adalah BrandCollectionView, setel ukuran sel
//        if collectionView == BrandCollectionView {
//            return CGSize(width: 160, height: 70)
//        }
//        
//        // Jika ini adalah collectionView untuk produk, setel ukuran sel
//        return CGSize(width: 160, height: 300)
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let product = products[indexPath.item]
//        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
//        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
//            detailViewController.product = product
//            navigationController?.pushViewController(detailViewController, animated: true)
//        }
//    }
//}
//
//extension HomeViewController: MenuViewControllerDelegate {
//    func didSelectMenuItem(_ menuItem: String) {
//        print("Selected menu item: \(menuItem)")
//    }
//}
