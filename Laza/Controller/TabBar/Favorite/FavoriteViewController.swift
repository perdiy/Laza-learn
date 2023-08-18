//
//  FavoriteViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 31/07/23.
//

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
        return 0 // Mengosongkan data
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Kode sel untuk tampilan sel kosong
        return UICollectionViewCell()
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Tidak ada navigasi ke DetailViewController
    }
}
