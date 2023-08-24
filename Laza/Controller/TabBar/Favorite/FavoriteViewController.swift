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
    
    var wishlistItems: [ProductWishlist] = []

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWishlistItems()
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
        guard let apiUrl = URL(string: "https://lazaapp.shop/wishlists") else {
            return
        }
        
        // Get token from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("User token not found.")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let wishlistResponse = try JSONDecoder().decode(Wishlist.self, from: data)
                let wishlistItems = wishlistResponse.data.products
                DispatchQueue.main.async {
                    self?.wishlistItems = wishlistItems
                    self?.collectionView.reloadData()
                    self?.updateWishlistCountLabel()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    func updateWishlistCountLabel() {
        let totalItems = wishlistItems.count
        jumlahWishlist.text = "Total Wishlist Items: \(totalItems)"
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let wishlistItem = wishlistItems[indexPath.item]
        
        cell.productLabel.text = wishlistItem.name
        cell.priceLabel.text = "$\(wishlistItem.price)"
        
        DispatchQueue.global().async {
            if let imageURL = URL(string: wishlistItem.imageURL),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.imgView.image = image
                }
            }
        }
        
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
  
 
