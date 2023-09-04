//
//  AddPaymentViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit
import Stripe
import CreditCardForm

class AddPaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    private var cardParams: STPPaymentMethodCardParams!
    let paymentTextField = STPPaymentCardTextField()
    var cardModels = [CreditCard]()
    var coredataManage = CoreDataM()
  
    @IBOutlet weak var cardOwner: UITextField!{
        didSet {
            cardOwner.addTarget(self, action: #selector(cardNameTextChanged(_:)), for: .editingChanged)
        }
    }
    @objc func cardNameTextChanged(_ textField: UITextField) {
        creditCardForm.cardHolderString = textField.text ?? ""
    }
    
    @IBOutlet weak var creditCardForm: CreditCardFormView!
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var textField: STPPaymentCardTextField!{
        didSet {
            textField.delegate = self
        }
    }

    
    // Tombol kembali
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mengatur delegasi untuk textField dari Stripe
        textField.delegate = self
        // Mengatur corner radius dan memotong sudut dari viewBack
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        textField.postalCodeEntryEnabled = false
        paymentTextField.delegate = self
        cardParams = STPPaymentMethodCardParams()
        self.textField.paymentMethodParams.card = cardParams
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedCard ()
    }
    @IBAction func addNewCard(_ sender: UIButton) {
        savedCard()
        saveCardModelToCoreData()
//        checkIfCardIsSaved()
        let addCard = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(identifier: "PaymentViewController") as! PaymentViewController
        addCard.cardModels = cardModels
        self.navigationController?.pushViewController(addCard, animated: true)
    }
    func savedCard (){
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: cardParams.number, expirationYear: cardParams!.expYear as? UInt, expirationMonth: cardParams!.expMonth as? UInt, cvc: cardParams.cvc)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardOwner {
            textField.resignFirstResponder()
            paymentTextField.becomeFirstResponder()
        } else if textField == cardOwner  {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func saveCardModelToCoreData() {
        let cardOwner = cardOwner.text ?? ""
        let cardNumber = textField.cardNumber ?? ""
        let cardExpMonth = " \(textField.expirationMonth)"
        let cardYear = " \(textField.expirationYear)"
        let cardCvv = textField.cvc ?? ""
        
        let newCard = CreditCard(
            cardOwner: cardOwner,
            cardNumber: cardNumber,
            cardExpMonth: cardExpMonth,
            cardExpYear: cardYear,
            cardCvv: cardCvv
        )
        print("list new card\(newCard)")
        coredataManage.create(newCard) 
            cardModels.append(newCard)
            print("Sukses menyimpan kartu ke Core Data")
    }
//    func checkIfCardIsSaved() {
//        let savedCards = coredataManage.retrieve(completion: <#T##([CreditCard]) -> Void#>, )
//        let cardOwnerToCheck = cardOwner.text
//
//        if savedCards.contains(where: { $0.cardOwner == cardOwnerToCheck }) {
//            print("Kartu sudah tersimpan di Core Data")
//        } else {
//            print("Kartu belum tersimpan di Core Data")
//        }
//    }
    
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingCVC()
    }
}
