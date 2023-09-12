//
//  ProTableViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit

// Protokol untuk mengirimkan aksi dari sel tampilan produk (cell) ke tampilan utama (view controller).
protocol ProductCellProtocol {
    func goToDetailProduct(product: DatumProdct) // Variabel untuk menyimpan data produk.
    func goToAllProduct(productAll: [DatumProdct])
}

class ProTableViewCell: UITableViewCell {
    
    @IBAction func allProductButton(_ sender: Any) {
        delegateProductProtocol?.goToAllProduct(productAll: self.products)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    var products: [DatumProdct] = [] // Delegat untuk mengirim aksi ke tampilan utama.
    var delegateProductProtocol : ProductCellProtocol? 
    
    // Mengatur tampilan sel tampilan produk berdasarkan data yang diberikan.
    func configure(data: [DatumProdct]){
        products = data
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProCollectionViewCell")
    }
}

// Mengimplementasikan sumber data koleksi untuk koleksi produk di dalam sel.
extension ProTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = products[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProCollectionViewCell", for: indexPath) as? ProCollectionViewCell else { return UICollectionViewCell() }
        cell.NameProLabel.text = product.name
        cell.priceProLabel.text = "$\(product.price)"
        DispatchQueue.global().async {
            if let imageURL = URL(string: product.imageURL), let imageData = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    cell.imageView.image = image
                }
            }
        }
        return cell
    }
}

// Mengimplementasikan delegat koleksi untuk menangani tindakan pemilihan sel produk. ke detail
extension ProTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateProductProtocol?.goToDetailProduct(product: products[indexPath.item])
    }
}

extension ProTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 280)
    }
}
