//
//  FavoriteViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 31/07/23.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell nib
        let nib = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FavoriteCollectionViewCell")

        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Set UICollectionViewFlowLayout properties
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 260)
        collectionView.collectionViewLayout = layout
        
        setupTabBarItemImage()
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Wishlist"
        label.textColor = UIColor(named: "PurpleButton")
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }

}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell

        cell.productLabel.text = "Produk \(indexPath.row + 1)"
        cell.priceLabel.text = "$19.99"
        cell.imgView.image = UIImage(named: "Rectangle 569")

        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
//            detailViewController.selectedProductIndex = indexPath.row
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}


