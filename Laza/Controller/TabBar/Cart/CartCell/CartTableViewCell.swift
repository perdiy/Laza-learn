//
//  CartTableViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    var currentNumber = 0 {
        didSet {
            jumlahLabel.text = "\(currentNumber)"
        }
    }
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var jumlahLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func increaseBtnTapped(_ sender: Any) {
        currentNumber += 1
    }
    
    @IBAction func decreaseBtnTapped(_ sender: Any) {
        if currentNumber > 0 {
            currentNumber -= 1
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
