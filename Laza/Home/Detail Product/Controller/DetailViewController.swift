//
//  DetailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//

import UIKit
import Cosmos
import SnackBar

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    var viewModelFav = FavoriteViewModel()
    var sizes: [SizeDetailProd] = []
    var productId: Int!
    var reviews = [Review]()
    var product: DatumProdct?
    var wishlistItem: ProductWishlist?
    var selectedSizeId: Int?
    var imageName: String = ""
    var wishlistItems: [ProductWishlist] = []
    
    @IBOutlet weak var loveView: UIView!
    @IBOutlet weak var viewBack: UIView!
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
    @IBOutlet weak var loveButtonOutlet: UIButton!
    @IBAction func addToCart(_ sender: Any) {
        addToCartWithSnackBar()
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
        updateLoveButtonStatus()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        loveView.layer.cornerRadius = loveView.bounds.height / 2.0
        loveView.clipsToBounds = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "SizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeCollectionViewCell")
        
        viewModel = DetailViewModel()
        viewModel.delegate = self
        viewModel.fetchSizes(for: productId)
        detailProductApi()
        
        fetchWishlistItems(productId: productId) { isInWishlist in
            if isInWishlist {
                self.imageName = "heart.fill"
            } else {
                self.imageName = "heart"
            }
            DispatchQueue.main.async {
                // Update the button image
                let image = UIImage(systemName: self.imageName)
                self.loveButtonOutlet.setImage(image, for: .normal)
            }
        }
    }
    
    func addToCartWithSnackBar() {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("User token not available.")
            return
        }
        
        guard let productID = productId, let sizeID = selectedSizeId else {
            print("Product ID or Size ID is nil.")
            return
        }
        
        viewModel.addProducInCart(ProductId: productID, SizeId: sizeID, userToken: token) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    SnackBar.make(in: self.view, message: "Product added to cart successfully.", duration: .lengthLong).show()
                }
            case .failure(let error):
                print("Error adding product to cart: \(error)")
            }
        }
    }

    
    func detailProductApi() {
        viewModel.getDataDetailProduct(id: productId) { [weak self] productDetail in
            DispatchQueue.main.async {
                if let product = productDetail?.data {
                    self?.reviews.append(contentsOf: product.reviews)
                    self?.titleLabel.text = product.name
                    self?.priceLabel.text = String("$ \(product.price)")
                    self?.descLabel.text = product.description
                    self?.productImageView.loadImageFromURL(url: product.imageURL)
                   
                    if let reviewProductFirst = self?.reviews.first{
                        self?.ratingLabel.text = String(reviewProductFirst.rating)
                        self?.star.rating = Double(reviewProductFirst.rating)
                        self?.fullNameLabel.text = String(reviewProductFirst.fullName)
                        self?.dateLabel.text = DateTimeUtils.shared.formatReview(date: reviewProductFirst.createdAt)
                        self?.commentLabel.text = String(reviewProductFirst.comment)
                    }
                } else {
                    print("productDetail data is nil")
                }
            }
        }
    }
    
    
    func fetchWishlistItems(productId: Int, completion: @escaping (Bool) -> Void) {
        guard let token = KeychainManager.shared.getAccessToken() else {
            print("User token not found.")
            completion(false)
            return
        }
        
        viewModelFav.fetchWishlistItems(token: token) { [weak self] wishlistItems in
            DispatchQueue.main.async {
                self?.wishlistItems = wishlistItems
                if wishlistItems.contains(where: { $0.id == productId }) {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func updateLoveButtonStatus() {
        guard let token = KeychainManager.shared.getAccessToken()else {
            print("User token not available.")
            return
        }
        
        viewModel.putWishlistUser(productId: productId, userToken: token) { result in
            switch result {
            case .success:
                self.viewModel.apiAlertDetailProduct = { status, data in
                    DispatchQueue.main.async {
                        print(data)
                        if data.contains("added") {
                            self.imageName = "heart.fill"
                        } else {
                            self.imageName = "heart"
                        }
                        let image = UIImage(systemName: self.imageName)
                        self.loveButtonOutlet.setImage(image, for: .normal) // Update the button image here
                        
                        // Show snackbar for success
                        SnackBar.make(in: self.view, message: data, duration: .lengthLong).show()
                    }
                }
                print("sukses add wishlist")
            case .failure(let error):
                // Handle the error case here if needed
                print("API update wishlist Error: \(error)")
            }
        }
    }
    
    
    func showAddToWishlistAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
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
            selectedCell.backgroundColor = UIColor(red: 151/255, green: 117/255, blue: 250/255, alpha: 1.0)
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

