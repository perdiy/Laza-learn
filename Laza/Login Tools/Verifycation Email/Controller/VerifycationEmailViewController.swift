//
//  VerifycationEmailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//

import UIKit

class VerifycationEmailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailAddressView: UITextField!
    @IBOutlet weak var verifyEmailBtnView: UIButton!
    
    // ViewModel untuk verifikasi email
    let verifyEmailViewModel = VerifyEmailViewModel()
    
    // Indikator aktivitas untuk tampilan loading
    var activityIndicator: UIActivityIndicatorView!
    
    // Tombol Kembali
    private lazy var backBtn : UIButton = {
        // Membuat tombol kembali
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage(named: "Back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return backBtn
    }()
    
    // Aksi untuk tombol Kembali
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Menambahkan tombol kembali kustom ke bilah navigasi
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backBarBtn
        
        // Menginisialisasi indikator aktivitas
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Mengonfigurasi constraints untuk indikator aktivitas
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Menonaktifkan tombol verifikasi email pada awalnya
        verifyEmailBtnView.isEnabled = false
        
        // Menambahkan target ke field alamat email untuk memicu validasi
        emailAddressView.addTarget(self, action: #selector(cekValidasi), for: .editingChanged)
    }
    
    // MARK: - Fungsi Validasi Email
    @objc private func cekValidasi() {
        let isEmailValid = emailAddressView.validEmail(emailAddressView.text ?? "")
        
        if emailAddressView.text?.isEmpty ?? true {
            verifyEmailBtnView.isEnabled = false
            verifyEmailBtnView.backgroundColor = UIColor.gray
        } else if isEmailValid {
            verifyEmailBtnView.isEnabled = true
            verifyEmailBtnView.backgroundColor = UIColor(red: 0.592, green: 0.459, blue: 0.980, alpha: 1.0)
        } else {
            verifyEmailBtnView.isEnabled = false
            verifyEmailBtnView.backgroundColor = UIColor.systemRed
        }
    }
    
    // MARK: - Fungsi Memulai Loading
    private func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.backgroundColor = UIColor.lightGray
        }
    }

    // MARK: - Fungsi Menghentikan Loading
    private func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - Fungsi Verifikasi Email API
    func verifyEmailApi() {
        let email = emailAddressView.text ?? ""
        verifyEmailViewModel.sendVeifyEmail(email: email) { result in
            self.stopLoading()
            switch result {
            case .success :
                DispatchQueue.main.async {
                    // Menampilkan pesan sukses
                    ShowAlert.performAlertApi(on: self, title: "Berhasil", message: "Silakan periksa email Anda dan klik tautan verifikasi akun")
                    // Navigasi ke tampilan login
                    self.loginVc()
                }
                
            case .failure(let error):
                self.verifyEmailViewModel.apiVerifyEmail = { description in
                    DispatchQueue.main.async {
                        print("Tampil pesan kesalahan untuk kasus kegagalan - Pesan kesalahan: \(description)")
                        // Menampilkan pesan kesalahan
                        ShowAlert.forgotPassApi(on: self, title: "Pesan Kesalahan", message: description)
                    }
                }
                print("Error: \(error)")
            }
        }
    }
    
    // Navigasi ke Tampilan Login
    func loginVc() {
        // Ganti "NamaStoryboardAnda" dengan nama storyboard sesungguhnya
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        welcomeViewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }

    
    @IBAction func verifyEmailBtn(_ sender: UIButton) {
        startLoading()
        verifyEmailApi()
    }
}
