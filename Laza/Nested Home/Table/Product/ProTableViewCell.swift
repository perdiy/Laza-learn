//
//  ProTableViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit

protocol ProductCellProtocol {
    func goToDetailProduct(product: DatumProdct)
}

class ProTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var products: [DatumProdct] = []
    var delegateProductProtocol : ProductCellProtocol?
    
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

// navigate detail
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
