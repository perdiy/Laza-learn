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
    var ascSort = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allReview: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var sortButton: UIButton!{
        didSet{
            sortButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
            sortButton.setTitle("Sort", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        updateAllReviewLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAllReviewLabel()
        sortProduct()
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        sortProduct()
    }
    
    func sortProduct() {
        ascSort.toggle()
        sortProData()
    }
    
    func sortProData() {
        if ascSort {
            allProducts.sort { $0.name < $1.name }
            sortButton.setTitle("A-Z", for: .normal)
            sortButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        } else {
            allProducts.sort { $0.name > $1.name }
            sortButton.setTitle("Z-A", for: .normal)
            sortButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        }
        collectionView.reloadData()
    }
    
    func showAllProducts(products: [DatumProdct]) {
        allProducts = products
        collectionView.reloadData()
        updateAllReviewLabel()
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
        cell.imgProduct.loadImageFromURL(url: product.imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 280)
    }
    
    func updateAllReviewLabel() {
        let totalProducts = allProducts.count
        allReview.text = "\(totalProducts) Items"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = allProducts[indexPath.item]
        navigateToDetailViewController()
    }
    
    func navigateToDetailViewController() {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.productId = selectedProduct?.id
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
