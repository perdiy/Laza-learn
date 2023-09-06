//
//  CreditCardCollectionViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//

import UIKit
import CreditCardForm
import StripePaymentsUI

class CreditCardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CreditCardCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CreditCardCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var listCard: CreditCardFormView!
    
    var cardModel: [CreditCard] = []
    var coreDataManage = CoreDataM()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fillCardDataFromCoreData(card: CreditCard) {
        let cardOwner = card.cardOwner
        let cardNumber = card.cardNumber
        let cardExpMonth = card.cardExpMonth
        let cardExpYear = card.cardExpYear
        let cvc = card.cardCvv
        
        print("CardOwner \(cardOwner)")
        print("NomerKartu \(cardNumber)")
        print("epiredMonth \(cardExpMonth)")
        print("expiredYear \(cardExpYear)")
        
        creditCard.paymentCardTextFieldDidChange(cardNumber: cardNumber, expirationYear: UInt(cardExpYear), expirationMonth: UInt(cardExpMonth), cvc: String(cvc))
        creditCard.cardHolderString = cardOwner
    }
    
    private let creditCard: CreditCardFormView = {
            let card = CreditCardFormView()
            card.translatesAutoresizingMaskIntoConstraints = false
            return card
        }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupCard()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupCard()
       }
    
    private func setupCard() {
            contentView.addSubview(creditCard)
            NSLayoutConstraint.activate([
                creditCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                creditCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                creditCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                creditCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ])
        }
    
    // MARK: - Func Credit Card
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        listCard.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
        
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        listCard.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        listCard.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        listCard.paymentCardTextFieldDidEndEditingCVC()
    }
}
