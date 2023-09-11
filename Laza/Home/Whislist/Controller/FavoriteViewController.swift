//
//  FavoriteViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 31/07/23.
//

import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet weak var jumlahWishlist: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = FavoriteViewModel()
    var wishlistItems: [ProductWishlist] = []
    @IBOutlet weak var emptyLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 260)
        collectionView.collectionViewLayout = layout
        
        setupTabBarItemImage()
        
        emptyLb.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWishlistItems()
        collectionView.reloadData()
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
    
    func fetchWishlistItems() {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("User token not found.")
            return
        }
        
        // [weak self] Ini akan membantu menghindari potensi masalah seperti strong reference cycle.
        viewModel.fetchWishlistItems(token: token) { [weak self] wishlistItems in
            DispatchQueue.main.async {
                self?.wishlistItems = wishlistItems
                self?.collectionView.reloadData()
                self?.updateWishlistCountLabel()
            }
        }
    }
    
    func updateWishlistCountLabel() {
        let totalItems = wishlistItems.count
        jumlahWishlist.text = "\(totalItems) Items"
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if wishlistItems.count == 0 {
            emptyLb.isHidden = false
        } else {
            emptyLb.isHidden = true
        }
        return wishlistItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let wishlistItem = wishlistItems[indexPath.item]
        
        cell.productLabel.text = wishlistItem.name
        cell.priceLabel.text = "$\(wishlistItem.price)"
        cell.imgView.loadImageFromURL(url: wishlistItem.imageURL)
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWishlistItem = wishlistItems[indexPath.item]
        navigateToDetailViewController(with: selectedWishlistItem)
    }
    
    func navigateToDetailViewController(with wishlistItem: ProductWishlist) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil) // Replace with the actual storyboard name
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.productId = wishlistItem.id
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}


