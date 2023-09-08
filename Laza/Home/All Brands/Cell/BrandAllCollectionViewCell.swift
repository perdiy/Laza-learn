//
//  BrandAllCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 21/08/23.
//

import UIKit

class BrandAllCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameBrand: UILabel!
    @IBOutlet weak var imageBrand: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with nameBrandText: String, logoUrl: String) {
        nameBrand.text = nameBrandText
        
        // Load dan tampilkan gambar logo merek dari URL
        if let imageURL = URL(string: logoUrl) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.imageBrand.image = image
                    }
                }
            }
        }
    }
}
