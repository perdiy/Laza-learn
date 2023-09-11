//
//  EditCardViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 05/09/23.
//

import UIKit
import Stripe
import CreditCardForm

class EditCardViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    private var cardParams: STPPaymentMethodCardParams!
    let paymentTextField = STPPaymentCardTextField()
    var cardModels = [CreditCard]()
    var coredataManage = CoreDataM()
    var indexPathCardNumber: String?
    var editCardOwner: String = ""
    var editCardNumber: String = ""

    // Outlet untuk field pemilik kartu
    @IBOutlet weak var cardOwner: UITextField! {
        didSet {
            // Menambahkan target untuk mengikuti perubahan teks dalam field pemilik kartu
            cardOwner.addTarget(self, action: #selector(cardNameTextChanged(_:)), for: .editingChanged)
        }
    }

    // Fungsi yang dipanggil ketika teks dalam field pemilik kartu berubah
    @objc func cardNameTextChanged(_ textField: UITextField) {
        // Memperbarui nilai dalam creditCardForm sesuai dengan teks dalam field pemilik kartu
        creditCardForm.cardHolderString = textField.text ?? ""
    }

    // Outlet untuk CreditCardFormView, tampilan yang digunakan untuk memasukkan informasi kartu kredit
    @IBOutlet weak var creditCardForm: CreditCardFormView!

    // Outlet untuk tampilan latar belakang
    @IBOutlet weak var viewBack: UIView!

    // Outlet untuk STPPaymentCardTextField, yang digunakan untuk memasukkan informasi kartu kredit dengan Stripe
    @IBOutlet weak var textField: STPPaymentCardTextField! {
        didSet {
            textField.delegate = self
        }
    }

    // Fungsi untuk menghandle tombol kembali
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self

        // Mengatur sudut lengkungan dan meng-clip viewBack agar berbentuk bulat
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true

        // Menonaktifkan entri kode pos dalam STPPaymentCardTextField
        textField.postalCodeEntryEnabled = false

        // Menyiapkan objek cardParams untuk Stripe
        cardParams = STPPaymentMethodCardParams()
        self.textField.paymentMethodParams.card = cardParams
    }

    override func viewWillAppear(_ animated: Bool) {
        // Memastikan CreditCardForm sesuai dengan informasi kartu yang ada
        creditCardForm.paymentCardTextFieldDidChange(
            cardNumber: cardParams.number,
            expirationYear: cardParams!.expYear as? UInt,
            expirationMonth: cardParams!.expMonth as? UInt,
            cvc: cardParams.cvc
        )
    }

    // Fungsi yang dipanggil saat tombol Edit Card ditekan
    @IBAction func editCardBtn(_ sender: UIButton) {
        // Simpan data kartu jika diperlukan
        savedCard()

        // Perbarui data kartu ke Core Data
        updateCardToCoreData()

        // Cek apakah sudah ada instance PaymentViewController dalam navigation stack
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
            // Jika sudah ada, perbarui data kartu dan kembali ke tampilan tersebut
            existingCardViewController.cardModels = cardModels
            self.navigationController?.popToViewController(existingCardViewController, animated: true)
        } else {
            // Jika belum ada, buat instance baru dan tambahkan ke navigation stack
            let addCard = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(identifier: "PaymentViewController") as! PaymentViewController
            addCard.cardModels = cardModels
            self.navigationController?.pushViewController(addCard, animated: true)
        }
    }

    // Fungsi yang dipanggil ketika tombol Return pada keyboard ditekan
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardOwner {
            textField.resignFirstResponder()
            paymentTextField.becomeFirstResponder()
        } else if textField == cardOwner {
            textField.resignFirstResponder()
        }
        return true
    }

    // Fungsi untuk memperbarui CreditCardForm saat informasi kartu di STPPaymentCardTextField berubah
    func savedCard() {
        creditCardForm.paymentCardTextFieldDidChange(
            cardNumber: cardParams.number,
            expirationYear: UInt(textField.expirationYear),
            expirationMonth: UInt(textField.expirationMonth),
            cvc: textField.cvc
        )
    }

    // Fungsi untuk memperbarui data kartu ke Core Data
    func updateCardToCoreData() {
        guard let creditCardNumber = indexPathCardNumber else {
            print("Kosong")
            return
        }
        guard let dataUser = KeychainManager.shared.getProfileFromKeychain() else {return}
        
        let cardOwner = cardOwner.text ?? ""
        let cardNumber = textField.cardNumber ?? ""
        let cardExpMonth = textField.expirationMonth
        let cardYear = textField.expirationYear
        let cardCvv = Int(textField.cvc ?? "101") ?? 101

        let editCard = CreditCard(
            userId: Int32(dataUser.id),
            cardOwner: cardOwner,
            cardNumber: cardNumber,
            cardExpMonth: Int16(cardExpMonth),
            cardExpYear: Int16(cardYear),
            cardCvv: Int16(cardCvv)
        )

        // Memperbarui data kartu dalam Core Data
        coredataManage.update(editCard, cardNumber: creditCardNumber)
        cardModels.append(editCard)
        print("Sukses update kartu ke Core Data")
    }

    // Fungsi dari STPPaymentCardTextFieldDelegate yang dipanggil saat informasi kartu diubah
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Memperbarui CreditCardForm sesuai dengan informasi kartu yang diinputkan
        creditCardForm.paymentCardTextFieldDidChange(
            cardNumber: textField.cardNumber,
            expirationYear: UInt(textField.expirationYear),
            expirationMonth: UInt(textField.expirationMonth),
            cvc: textField.cvc
        )
    }

    // Fungsi dari STPPaymentCardTextFieldDelegate yang dipanggil saat pengeditan tahun kedaluwarsa selesai
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        // Memperbarui CreditCardForm sesuai dengan tahun kedaluwarsa yang diinputkan
        creditCardForm.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }

    // Fungsi dari STPPaymentCardTextFieldDelegate yang dipanggil saat pengeditan CVC dimulai
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        // Memperbarui CreditCardForm saat pengeditan CVC dimulai
        creditCardForm.paymentCardTextFieldDidBeginEditingCVC()
    }

    // Fungsi dari STPPaymentCardTextFieldDelegate yang dipanggil saat pengeditan CVC selesai
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        // Memperbarui CreditCardForm saat pengeditan CVC selesai
        creditCardForm.paymentCardTextFieldDidEndEditingCVC()
    }
}
