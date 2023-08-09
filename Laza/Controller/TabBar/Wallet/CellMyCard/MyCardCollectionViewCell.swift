//
//  MyCardCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//

import UIKit
import Stripe
import CreditCardForm

class MyCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myCard: CreditCardFormView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myCard.cardHolderString = "Perdi Yansyah"
        
        
    }

}
