//
//  CategoryTableViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionCategory: UICollectionView!
    var data: [String] = []
    
    @IBAction func viewAllButton(_ sender: Any) {if let productAllVC = UIStoryboard(name: "BrandAll", bundle: nil).instantiateViewController(withIdentifier: "BrandAllViewController") as? BrandAllViewController {
        productAllVC.modalPresentationStyle = .fullScreen
        productAllVC.receivedData = data
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(productAllVC, animated: false)
        }
    }
        
    }
    func configure(data: [String]) {
        self.data = data
        collectionCategory.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionCategory.dataSource = self
        collectionCategory.delegate = self
        collectionCategory.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataCell = data[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: dataCell)
        return cell
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = data[indexPath.item]
        navigateToProductByBrand(with: selectedCategory)
    }
    
    func navigateToProductByBrand(with categoryName: String) {
        if let productByBrandVC = UIStoryboard(name: "ProductByBrand", bundle: nil).instantiateViewController(withIdentifier: "prductByBrandViewController") as? prductByBrandViewController {
            productByBrandVC.brandName = categoryName
            
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                navigationController.pushViewController(productByBrandVC, animated: true)
            }
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
    }
}





