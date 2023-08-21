//
//  ProductAllViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 21/08/23.
//

import UIKit

class ProductAllViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var allProducts: [DatumProdct] = []
    var selectedProduct: DatumProdct?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allReview: UILabel!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func sortButton(_ sender: Any) {
        // Handle sorting logic here
    }
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        updateAllReviewLabel() // Menampilkan jumlah produk saat tampilan dimuat
    }
    
    func showAllProducts(products: [DatumProdct]) {
        allProducts = products
        collectionView.reloadData()
        updateAllReviewLabel() // Memperbarui label jumlah produk
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductAllCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductAllCollectionViewCell", for: indexPath) as! ProductAllCollectionViewCell
        
        let product = allProducts[indexPath.item]
        cell.nameProduct.text = product.name
        cell.priceProduct.text = "$\(product.price)"
        
        DispatchQueue.global().async {
            if let imageURL = URL(string: product.imageURL),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.imgProduct.image = image
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 280)
    }
    
    func updateAllReviewLabel() {
        let totalProducts = allProducts.count
        allReview.text = "\(totalProducts) Items"
    }
}

