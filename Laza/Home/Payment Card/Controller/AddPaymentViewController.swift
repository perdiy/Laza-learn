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
    
    // Properti untuk menyimpan informasi kartu pembayaran
    private var cardParams: STPPaymentMethodCardParams!
    // TextField untuk memasukkan informasi kartu pembayaran
    let paymentTextField = STPPaymentCardTextField()
    // Array untuk menyimpan model kartu pembayaran
    var cardModels = [CreditCard]()
    // Objek untuk mengelola Core Data
    var coredataManage = CoreDataM()
    
    @IBOutlet weak var cardOwner: UITextField!{
        didSet {
            // Menambahkan target untuk memantau perubahan teks pada cardOwner
            cardOwner.addTarget(self, action: #selector(cardNameTextChanged(_:)), for: .editingChanged)
        }
    }
    
    // Tindakan yang dipanggil ketika teks pada cardOwner berubah
    @objc func cardNameTextChanged(_ textField: UITextField) {
        creditCardForm.cardHolderString = textField.text ?? ""
    }
    
    @IBOutlet weak var creditCardForm: CreditCardFormView!
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var textField: STPPaymentCardTextField!{
        didSet {
            // Mengatur delegasi untuk textField dari Stripe
            textField.delegate = self
        }
    }
    
    // Tindakan tombol Kembali
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mengatur delegasi untuk textField dari Stripe
        textField.delegate = self
        // Mengatur sudut lengkungan dan memotong sudut dari viewBack
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        textField.postalCodeEntryEnabled = false
        paymentTextField.delegate = self
        cardParams = STPPaymentMethodCardParams()
        self.textField.paymentMethodParams.card = cardParams
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Memuat kartu yang sudah disimpan
        savedCard()
    }
    
    @IBAction func addNewCard(_ sender: UIButton) {
        // Simpan data kartu jika diperlukan
        savedCard()
        saveCardModelToCoreData()
        
        // Cek apakah ada instance PaymentViewController yang sudah ada dalam navigation stack
        var foundCardViewController: PaymentViewController?
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if let cardViewController = viewController as? PaymentViewController {
                    foundCardViewController = cardViewController
                    break
                }
            }
        }
        
        if let existingCardViewController = foundCardViewController {
            // Jika sudah ada, tinggal perbarui data kartu dan kembali ke tampilan tersebut
            existingCardViewController.cardModels = cardModels
            self.navigationController?.popToViewController(existingCardViewController, animated: false)
        } else {
            // Jika belum ada, buat instance baru dan tambahkan ke navigation stack
            let addCard = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(identifier: "PaymentViewController") as! PaymentViewController
            addCard.cardModels = cardModels
            self.navigationController?.pushViewController(addCard, animated: false)
        }
    }
    
    // Fungsi untuk memuat data kartu yang sudah disimpan
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
    
    // Fungsi untuk menyimpan model kartu ke Core Data
    func saveCardModelToCoreData() {
        
        guard let dataUser = KeychainManager.shared.getProfileFromKeychain() else {return}
        
        let cardOwner = cardOwner.text ?? ""
        let cardNumber = textField.cardNumber ?? ""
        let cardExpMonth = textField.expirationMonth
        let cardYear = textField.expirationYear
        let cardCvv = Int(textField.cvc ?? "123") ?? 133
        
        let newCard = CreditCard(
            userId: Int32(dataUser.id),
            cardOwner: cardOwner,
            cardNumber: cardNumber,
            cardExpMonth: Int16(cardExpMonth),
            cardExpYear: Int16(cardYear),
            cardCvv: Int16(cardCvv)
        )
        
        
        // Menyimpan model kartu ke Core Data
        coredataManage.create(newCard)
        cardModels.append(newCard)
        print("Sukses menyimpan kartu ke Core Data")
    }
    
    // Fungsi dari STPPaymentCardTextFieldDelegate untuk memantau perubahan pada TextField Stripe
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
    }
    
    // Fungsi dari STPPaymentCardTextFieldDelegate untuk mengakhiri pengeditan tahun kedaluwarsa
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    // Fungsi dari STPPaymentCardTextFieldDelegate yang dipanggil saat pengguna mulai mengedit CVC
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    // Fungsi dari STPPaymentCardTextFieldDelegate yang dipanggil saat pengguna selesai mengedit CVC
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingCVC()
    }
}
