//
//  BrandCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!{
        didSet {
            whiteView.layer.cornerRadius = 8
            whiteView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var brandLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}