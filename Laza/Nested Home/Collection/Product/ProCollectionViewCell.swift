//
//  ProCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//
import UIKit

class ProCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewImg: UIView! {
        didSet {
            viewImg.layer.cornerRadius = 80
            viewImg.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var priceProLabel: UILabel!
    @IBOutlet weak var NameProLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func configure(with product: DatumProdct) {
        NameProLabel.text = product.name
        priceProLabel.text = "$\(product.price)"
        
        // Fetch the product image from the URL and set it to the imageView
        DispatchQueue.global().async {
            if let imageURL = URL(string: product.imageURL),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}



