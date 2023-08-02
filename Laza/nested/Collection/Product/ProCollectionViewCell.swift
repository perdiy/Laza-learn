//
//  ProCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//
import UIKit

class ProCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var priceProLabel: UILabel!
    @IBOutlet weak var NameProLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func configure(with product: Product) {
        NameProLabel.text = product.title
        priceProLabel.text = "$\(product.price)"
        
        // Fetch the product image from the URL and set it to the imageView
        DispatchQueue.global().async {
            if let imageURL = URL(string: product.image),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}



