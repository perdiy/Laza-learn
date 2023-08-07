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
        layout.itemSize = CGSize(width: 150, height: 260
        )
        collectionView.collectionViewLayout = layout
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
    // Implement any delegate methods if needed
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    // Implement layout customization methods if needed
}

