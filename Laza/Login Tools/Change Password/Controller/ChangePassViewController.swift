//
//  ChangePassViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/09/23.
//

// Import UIKit untuk menggunakan UI components
// Import ChangePasswordModel untuk mengelola perubahan kata sandi
// Deklarasikan class ChangePassViewController yang merupakan view controller untuk mengganti kata sandi

import UIKit

class ChangePassViewController: UIViewController {
    
    // Inisialisasi view model untuk mengelola perubahan kata sandi
    private let viewModel = ChangePasswordModel()
    
    // Deklarasikan variabel iconClick untuk mengontrol tampilan karakter kata sandi
    var iconClick = true
    
    // Outlets untuk elemen antarmuka pengguna
    // Mengaitkan teks field kata sandi lama dengan kode
    @IBOutlet weak var oldPaswordTf: UITextField! {
        didSet {
            // Menambahkan efek bayangan dan target untuk mengikuti perubahan teks
            oldPaswordTf.addShadow(color: .gray, widht: 0.5, text: oldPaswordTf)
            oldPaswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    // Mengaitkan tombol kembali dengan kode
    @IBOutlet weak var viewBack: UIView!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Mengaitkan teks field kata sandi baru dengan kode
    @IBOutlet weak var newPasswordTf: UITextField! {
        didSet {
            // Menambahkan efek bayangan dan target untuk mengikuti perubahan teks
            newPasswordTf.addShadow(color: .gray, widht: 0.5, text: newPasswordTf)
            newPasswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    // Mengaitkan teks field konfirmasi kata sandi dengan kode
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            // Menambahkan efek bayangan dan target untuk mengikuti perubahan teks
            confirmPasswordTf.addShadow(color: .gray, widht: 0.5, text: confirmPasswordTf)
            confirmPasswordTf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    // Mengaitkan label kekuatan kata sandi konfirmasi dengan kode
    @IBOutlet weak var strongConfirmPassLb: UILabel!
    
    // Mengaitkan label kekuatan kata sandi baru dengan kode
    @IBOutlet weak var storngNewPassLb: UILabel!
    
    // Mengaitkan tombol untuk mengganti kata sandi dengan kode
    @IBOutlet weak var buttonChangePassword: UIButton!
    
    // Mengaitkan aksi untuk menyembunyikan kata sandi lama dengan kode
    @IBAction func hideOldPassword(_ sender: Any) {
        iconClick.toggle()
        oldPaswordTf.isSecureTextEntry = !iconClick
    }
    
    // Mengaitkan aksi untuk menyembunyikan kata sandi baru dengan kode
    @IBAction func hideNewPassword(_ sender: Any) {
        iconClick.toggle()
        newPasswordTf.isSecureTextEntry = !iconClick
    }
    
    // Mengaitkan aksi untuk menyembunyikan konfirmasi kata sandi dengan kode
    @IBAction func hideConfirmPassword(_ sender: Any) {
        iconClick.toggle()
        confirmPasswordTf.isSecureTextEntry = !iconClick
    }
    
    // Metode yang dipanggil saat tampilan dimuat
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mengatur sudut lengkungan dan meng-clip viewBack agar berbentuk bulat
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Memanggil metode textFieldDidChange untuk memastikan tombol ganti kata sandi dinonaktifkan saat tampilan dimuat
        textFieldDidChange()
    }
    
    // Metode yang dipanggil saat teks field berubah
    @objc func textFieldDidChange() {
        // Memeriksa apakah teks field kata sandi lama kosong atau tidak
        let oldPasswordIsEmpty = oldPaswordTf.text?.isEmpty ?? true
        
        // Memeriksa apakah teks field kata sandi baru kosong atau tidak
        let newPasswordIsEmpty = newPasswordTf.text?.isEmpty ?? true
        
        // Memeriksa apakah teks field konfirmasi kata sandi kosong atau tidak
        let confirmPasswordIsEmpty = confirmPasswordTf.text?.isEmpty ?? true
        
        // Mengaktifkan atau menonaktifkan tombol ganti kata sandi berdasarkan kondisi di atas
        buttonChangePassword.isEnabled = !oldPasswordIsEmpty && !newPasswordIsEmpty && !confirmPasswordIsEmpty
        
        // Mengubah opasitas tombol ganti kata sandi sesuai dengan keaktifannya
        buttonChangePassword.alpha = buttonChangePassword.isEnabled ? 1.0 : 0.5
        
        // Menyembunyikan atau menampilkan label kekuatan kata sandi baru berdasarkan panjang kata sandi
        storngNewPassLb.isHidden = !(newPasswordTf.text?.count ?? 0 >= 8)
        
        // Menyembunyikan atau menampilkan label kekuatan konfirmasi kata sandi berdasarkan panjang kata sandi
        strongConfirmPassLb.isHidden = !(confirmPasswordTf.text?.count ?? 0 >= 8)
    }
    
    // Aksi saat tombol ganti kata sandi ditekan
    @IBAction func buttonChangePasswordTapped(_ sender: Any) {
        // Memanggil metode untuk mengirim permintaan perubahan kata sandi
        putChangePassword()
    }
    
    // Metode untuk mengirim permintaan perubahan kata sandi
    func putChangePassword() {
        // Mengambil nilai teks dari teks field kata sandi lama, kata sandi baru, dan konfirmasi kata sandi
        let oldPassword = oldPaswordTf.text ?? ""
        let newPassword = newPasswordTf.text ?? ""
        let confirmNewPassword = confirmPasswordTf.text ?? ""
        
        // Menggunakan view model untuk mengirim permintaan perubahan kata sandi
        viewModel.getPass(oldPassword: oldPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) { result in
            switch result {
            case .success(let json):
                // [weak self] Ini akan membantu menghindari potensi masalah seperti strong reference cycle.
                // Panggil metode untuk menampilkan pesan sukses ketika kata sandi berhasil diganti
                self.viewModel.alertChangePassword = { [weak self] successMessage in
                    DispatchQueue.main.async {
                        // Tampilkan alert ketika berhasil mengganti kata sandi
                        let successAlert = UIAlertController(title: "Success", message: successMessage, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            // Kembali ke tampilan sebelumnya atau lakukan navigasi yang sesuai
                            self?.navigationController?.popViewController(animated: true)
                        })
                        successAlert.addAction(okAction)
                        self?.present(successAlert, animated: true, completion: nil)
                    }
                }
                print("Response JSON: \(String(describing: json))")
            case .failure(let error):
                // Menangani pesan kesalahan dan menampilkan pesan kesalahan kepada pengguna
                self.viewModel.alertChangePassword = { description in
                    DispatchQueue.main.async {
                        // Menampilkan pesan kesalahan dalam bentuk alert
                        ShowAlert.forgotPassApi(on: self, title: "Error Message", message: description)
                    }
                }
                print("Error: \(error)")
                // Menangani kesalahan dengan benar sesuai kebutuhan
            }
        }
    }
}
