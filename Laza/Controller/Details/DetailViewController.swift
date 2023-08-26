//
//  DetailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    var sizes: [SizeDetailProd] = []
    var productId: Int!
    var reviews = [Review]()
    var product: DatumProdct?
    var wishlistItem: ProductWishlist?
    var selectedSizeId: Int?
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var loveButtonOutlet: UIButton! // Outlet for the love button
    
    @IBAction func addToCart(_ sender: Any) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("User token not available.")
            return
        }
        
        guard let productID = productId, let sizeID = selectedSizeId else {
            print("Product ID or Size ID is nil.")
            return
        }
        
        viewModel.addProducInCart(ProductId: productID, SizeId: sizeID, userToken: token) { cartProduct in
            print("Product added to cart!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "SizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeCollectionViewCell")
        
        viewModel = DetailViewModel()
        viewModel.delegate = self
        viewModel.fetchSizes(for: productId)
        detailProductApi()
    }
    
    func detailProductApi() {
        viewModel.getDataDetailProduct(id: productId) { [weak self] productDetail in
            DispatchQueue.main.async {
                if let product = productDetail?.data {
                    self?.reviews.append(contentsOf: product.reviews)
                    self?.titleLabel.text = product.name
                    self?.priceLabel.text = String("$ \(product.price)")
                    self?.descLabel.text = product.description
                    
                    if let imageUrl = URL(string: product.imageURL) {
                        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.productImageView.image = image
                                }
                            }
                        }.resume()
                    }
                    if let reviewProductFirst = self?.reviews.first{
                        self?.ratingLabel.text = String(reviewProductFirst.rating)
                        self?.star.rating = Double(reviewProductFirst.rating)
                        self?.fullNameLabel.text = String(reviewProductFirst.fullName)
                        self?.dateLabel.text = String(reviewProductFirst.createdAt)
                        self?.commentLabel.text = String(reviewProductFirst.comment)
                    }
                } else {
                    print("productDetail data is nil")
                }
            }
        }
    }
    
    @IBAction func reviewBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        if let reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController {
            reviewViewController.productId = productId
            self.navigationController?.pushViewController(reviewViewController, animated: true)
        }
    }
    
    @IBAction func backArrowTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loveButton(_ sender: Any) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("User token not available.")
            return
        }
        
        if let wishlistItem = wishlistItem {
            removeProductFromWishlist(wishlistItem, token: token)
            updateLoveButtonStatus(isInWishlist: false)
            self.wishlistItem = nil
        } else {
            addProductToWishlist(productId: productId, token: token)
            updateLoveButtonStatus(isInWishlist: true)
        }
    }
    
    func addProductToWishlist(productId: Int, token: String) {
        let urlString = "https://lazaapp.shop/wishlists?ProductId=\(productId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for adding to wishlist.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding product to wishlist: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Product added to wishlist!")
                    DispatchQueue.main.async {
                        self.showAddToWishlistAlert()
                    }
                } else {
                    print("Failed to add product to wishlist. Status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func removeProductFromWishlist(_ wishlistItem: ProductWishlist, token: String) {
        // Implement the code to remove a product from the wishlist here
        // You mentioned that the API doesn't have a delete case for this, so you might need to implement it differently based on the API behavior
        // For now, I'll leave this as a placeholder
    }
    
    func updateLoveButtonStatus(isInWishlist: Bool) {
        let systemImageName = isInWishlist ? "heart.fill" : "heart"
        if let systemImage = UIImage(systemName: systemImageName) {
            loveButtonOutlet.setImage(systemImage, for: .normal)
        }
    }
    
    func showAddToWishlistAlert() {
        let alert = UIAlertController(title: "Success", message: "Product added to wishlist!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) {
            selectedCell.backgroundColor = .systemBlue
        }
        
        for cell in collectionView.visibleCells {
            if let indexPathForCell = collectionView.indexPath(for: cell),
               indexPathForCell != indexPath {
                cell.backgroundColor = .gray
            }
        }
        selectedSizeId = sizes[indexPath.item].id
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as! SizeCollectionViewCell
        cell.sizeLabel.text = sizes[indexPath.item].size
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 40)
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func updateSizes(_ sizes: [SizeDetailProd]) {
        DispatchQueue.main.async {
            self.sizes = sizes
            self.collectionView.reloadData()
        }
    }
}
