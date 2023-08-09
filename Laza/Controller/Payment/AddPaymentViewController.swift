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
    
    @IBOutlet weak var creditCardForm: CreditCardFormView!
    let paymentTextField = STPPaymentCardTextField()
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var textField: STPPaymentCardTextField!
    
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
    }
    
    // Implementasi metode delegasi dari STPPaymentCardTextFieldDelegate
    // Dipanggil ketika isi dari STPPaymentCardTextField berubah
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
    }
    
    // Dipanggil saat pengguna selesai mengedit tahun kedaluwarsa
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    // Dipanggil saat pengguna memulai mengedit CVC
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    // Dipanggil saat pengguna selesai mengedit CVC
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingCVC()
    }
}
