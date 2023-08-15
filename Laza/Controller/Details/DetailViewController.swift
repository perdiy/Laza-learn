//
//  DetailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var sizes: [DatumSize] = []
    
    @IBOutlet weak var viewBack: UIView! {
        didSet {
            viewBack.layer.cornerRadius = viewBack.bounds.height / 2
            viewBack.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var dateCreateRating: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var product: DatumProdct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // lemparan data
        if let product = product {
            titleLabel.text = product.name
            priceLabel.text = "$ \(product.price)"
            
            if let imageUrl = URL(string: product.imageURL) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.productImageView.image = image
                        }
                    }
                }.resume()
            }
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "SizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeCollectionViewCell")
        
        fetchSizes()
    }
    
    @IBAction func reviewBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        if let reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController {
            self.navigationController?.pushViewController(reviewViewController, animated: true)
        }
    }
    
    @IBAction func backArrowTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchSizes() {
        guard let sizeURL = URL(string: "https://lazaapp.shop/size") else { return }
        
        let sizeTask = URLSession.shared.dataTask(with: sizeURL) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let sizeResponse = try decoder.decode(Size.self, from: data)
                DispatchQueue.main.async {
                    self.sizes = sizeResponse.data
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error fetching sizes: \(error.localizedDescription)")
            }
        }
        
        sizeTask.resume()
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
