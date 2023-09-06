//
//  ProductAllViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 21/08/23.
//

import UIKit

class ProductAllViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Data produk yang akan ditampilkan dalam koleksi
    var allProducts: [DatumProdct] = []
    
    // Produk yang dipilih
    var selectedProduct: DatumProdct?
    
    // Variabel untuk mengatur urutan penyortiran produk
    var ascSort = true
    
    // Outlet untuk elemen-elemen tampilan
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allReview: UILabel!
    @IBOutlet weak var viewBack: UIView!
    
    // Tombol untuk kembali ke tampilan sebelumnya
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Tombol untuk mengganti urutan penyortiran
    @IBOutlet weak var sortButton: UIButton! {
        didSet {
            sortButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
            sortButton.setTitle("Sort", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mengatur sudut lengkungan untuk latar belakang
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Mengatur tampilan koleksi
        setupCollectionView()
        
        // Memperbarui label untuk menampilkan jumlah produk
        updateAllReviewLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Memperbarui label jumlah produk dan melakukan penyortiran
        updateAllReviewLabel()
        sortProduct()
    }
    
    // Tombol untuk mengganti urutan penyortiran ditekan
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        sortProduct()
    }
    
    // Fungsi untuk mengganti urutan penyortiran
    func sortProduct() {
        ascSort.toggle()
        sortProData()
    }
    
    // Fungsi untuk melakukan penyortiran data produk
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
    
    // Menampilkan semua produk dalam koleksi
    func showAllProducts(products: [DatumProdct]) {
        allProducts = products
        collectionView.reloadData()
        updateAllReviewLabel()
    }
    
    // Mengatur koleksi tampilan produk
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductAllCollectionViewCell")
    }
    
    // Implementasi fungsi dataSource untuk koleksi
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
    
    // Mengatur ukuran sel dalam koleksi
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 280)
    }
    
    // Memperbarui label untuk menampilkan jumlah produk
    func updateAllReviewLabel() {
        let totalProducts = allProducts.count
        allReview.text = "\(totalProducts) Items"
    }
    
    // Menangani pemilihan item dalam koleksi
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = allProducts[indexPath.item]
        navigateToDetailViewController()
    }
    
    // Navigasi ke tampilan detail produk
    func navigateToDetailViewController() {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.productId = selectedProduct?.id
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
