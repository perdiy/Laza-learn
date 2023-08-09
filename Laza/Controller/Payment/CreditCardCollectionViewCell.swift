//
//  CreditCardCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//

import UIKit
import Stripe
import CreditCardForm

class CreditCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardCreditView: CreditCardFormView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
