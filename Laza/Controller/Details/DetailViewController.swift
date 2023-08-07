//
//  DetailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//


import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var viewBack: UIView!{
        didSet {
            viewBack.layer.cornerRadius = viewBack.bounds.height / 2
            viewBack.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var product: Product?
    var sizes: [String] = ["XS", "S", "M", "L", "XL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update UI with the product details
        if let product = product {
            titleLabel.text = product.title
            priceLabel.text = "$ \(product.price)"
            descriptionLabel.text = product.description
            
            if let imageUrl = URL(string: product.image) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.productImageView.image = image
                        }
                    }
                }.resume()
            }
        }
        
        // Set data source and delegate for the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register the SizeCollectionViewCell
        collectionView.register(UINib(nibName: "SizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeCollectionViewCell")
    }
    
    @IBAction func reviewBtn(_ sender: Any) {
        // Membuat instance ReviewViewController dari storyboard
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        if let reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController {
            self.navigationController?.pushViewController(reviewViewController, animated: true)
        }
    }
    
    @IBAction func backArrowTapped(_ sender: UIButton) {
        // Menggunakan navigationController untuk kembali ke view controller sebelumnya
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as! SizeCollectionViewCell
        
        // Konfigurasi cell dengan data ukuran
        cell.sizeLabel.text = sizes[indexPath.item]
        return cell
    }
    
    // Anda dapat memodifikasi fungsi ini untuk mengatur ukuran setiap cell berdasarkan kebutuhan desain Anda
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
}
