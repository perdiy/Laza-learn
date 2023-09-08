//
//  CategoryCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBrand: UIImageView!
    @IBOutlet weak var categoryTxt: UILabel!
    @IBOutlet weak var viewCa: UILabel! {
        didSet {
            viewCa.layer.cornerRadius = 8
            viewCa.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with category: String, imgBrand: String) {
        categoryTxt.text = category.capitalized
        imageBrand.loadImageFromURL(url: imgBrand)
    }
}

