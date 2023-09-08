//
//  CategoryTableViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit

protocol navigateToDetailBrand: AnyObject {
    func goToDetailBrand(branName: String, brandLogoUrl: String)
    func goToViewAllBrand(names: [String], logoURLs: [String])
}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    var data: [Description] = []
    
    weak var delegate: navigateToDetailBrand?
    
    @IBAction func viewAllButton(_ sender: Any) {
            let names = data.map { $0.name }
            let logoURLs = data.map { $0.logoURL }
            delegate?.goToViewAllBrand(names: names, logoURLs: logoURLs)
        }
    func configure(data: [Description]) {
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
        cell.configure(with: dataCell.name, imgBrand: dataCell.logoURL)
        return cell
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
        let selectedCategory = data[indexPath.item]
        delegate?.goToDetailBrand(branName: selectedCategory.name, brandLogoUrl: selectedCategory.logoURL)
        //        navigateToProductByBrand(with: selectedCategory.name, imageUrl: selectedCategory.logoURL)
    }
    
    func navigateToProductByBrand(with categoryName: String, imageUrl: String) {
        guard let productByBrandVC = UIStoryboard(name: "ProductByBrand", bundle: nil).instantiateViewController(withIdentifier: "prductByBrandViewController") as? prductByBrandViewController else {return}
        productByBrandVC.brandName = categoryName
        productByBrandVC.imgUrl = imageUrl
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(productByBrandVC, animated: true)
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
    }
}





