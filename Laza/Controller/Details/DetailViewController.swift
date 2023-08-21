//
//  DetailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//
 
import UIKit

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    var sizes: [SizeDetailProd] = []
    var productId: Int!
    var reviews = [Review]()
    var product: DatumProdct?
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
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
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
                        self?.fullNameLabel.text = String(reviewProductFirst.fullName)
                        self?.dateLabel.text = String(reviewProductFirst.createdAt)
                        self?.commentLabel.text = String(reviewProductFirst.comment)
                    }
//                    if let reviewProduct = self?.reviews.first {
//                        self?.ratingLabel.text = String(reviewProduct.rating)
//                        self?.fullNameLabel.text = reviewProduct.fullName
//                        self?.dateLabel.text = reviewProduct.createdAt
//                        self?.commentLabel.text = reviewProduct.comment
//                        
//                        if let imageUrl = URL(string: reviewProduct.imageURL) {
//                            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
//                                if let data = data, let image = UIImage(data: data) {
//                                    DispatchQueue.main.async {
//                                        self?.imageUser.image = image
//                                    }
//                                } else {
//                                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
//                                }
//                            }.resume()
//                        }
//                    }
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
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as! SizeCollectionViewCell
        cell.sizeLabel.text = sizes[indexPath.item].size
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
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
