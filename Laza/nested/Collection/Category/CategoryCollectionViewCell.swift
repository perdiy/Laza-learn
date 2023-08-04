//
//  CategoryCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 01/08/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTxt: UILabel!
    @IBOutlet weak var viewCa: UILabel! {
        didSet {
            viewCa.layer.cornerRadius = 8
            viewCa.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with category: String) {
        categoryTxt.text = category.capitalized
    }
}

