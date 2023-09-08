//
//  PaymentMethodeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//

import UIKit

class PaymentMethodeViewController: UIViewController {
    
    // IB Outlets untuk elemen-elemen antarmuka pengguna
    @IBOutlet weak var viewBack: UIView!
    @IBAction func backBtn(_ sender: Any) {
        // Mengatur tindakan tombol Kembali untuk mempop view controller saat ini
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var checkBtnOvo: UIButton!
    @IBOutlet weak var checkBtnCardCredit: UIButton!
    @IBOutlet weak var btnPayment: UIButton!
    
    // Menyimpan status apakah tombol GoPay dan Kartu Kredit tercentang
    var isOvoChecked = false
    var isCardCreditChecked = false
    
    // Tindakan yang dipanggil ketika tombol "GoPay" (OVO) ditekan
    @IBAction func checkBtnOvo(_ sender: Any) {
        // Mengubah status tercentang GoPay dan memastikan Kartu Kredit tidak tercentang
        isOvoChecked = true
        isCardCreditChecked = false
        updateCheckBtnImage(checkBtnOvo, isChecked: isOvoChecked)
        updateCheckBtnImage(checkBtnCardCredit, isChecked: isCardCreditChecked)
        updatePaymentButtonState()
    }
    
    // Tindakan yang dipanggil ketika tombol "Kartu Kredit" ditekan
    @IBAction func checkBtnCardCredit(_ sender: Any) {
        // Mengubah status tercentang Kartu Kredit dan memastikan GoPay tidak tercentang
        isCardCreditChecked = true
        isOvoChecked = false
        updateCheckBtnImage(checkBtnCardCredit, isChecked: isCardCreditChecked)
        updateCheckBtnImage(checkBtnOvo, isChecked: isOvoChecked)
        updatePaymentButtonState()
    }
    
    // Tindakan yang dipanggil ketika tombol "Bayar" ditekan
    @IBAction func btnPayment(_ sender: Any) {
        // Cek opsi yang dipilih dan lakukan navigasi sesuai dengan opsi yang dipilih
        if isOvoChecked {
            // Alihkan ke URL GoPay (contoh URL, sesuaikan dengan URL yang benar)
            if let gopayURL = URL(string: "https://www.gojek.com/gopay") {
                UIApplication.shared.open(gopayURL)
            }
        } else if isCardCreditChecked {
            // Navigasi ke halaman PaymentViewController (contoh navigasi, sesuaikan dengan tampilan yang benar)
            let storyboard = UIStoryboard(name: "Payment", bundle: nil)
            if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
                navigationController?.pushViewController(paymentVC, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePaymentButtonState()
        // Mengatur sudut lengkungan dan meng-clip viewBack agar berbentuk bulat
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    // Fungsi untuk memperbarui gambar tombol centang (checkbox)
    private func updateCheckBtnImage(_ button: UIButton, isChecked: Bool) {
        let systemImageName = isChecked ? "checkmark.square" : "square"
        if let systemImage = UIImage(systemName: systemImageName) {
            button.setImage(systemImage, for: .normal)
        }
    }
    
    // Fungsi untuk memperbarui status tombol pembayaran berdasarkan pilihan OVO atau Kartu Kredit
    private func updatePaymentButtonState() {
        let isEnabled = isOvoChecked || isCardCreditChecked
        btnPayment.isEnabled = isEnabled
        btnPayment.backgroundColor = isEnabled ? UIColor(red: 151/255, green: 117/255, blue: 250/255, alpha: 1.0) : UIColor.gray
    }
}
