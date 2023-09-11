//
//  VerifycationEmailCodeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//

import UIKit
import DPOTPView

class VerifycationEmailCodeViewController: UIViewController {
    @IBOutlet weak var waktuVerifikasi: UILabel!
    @IBAction func comfirmCode(_ sender: Any) {
        // Implementasikan tindakan yang sesuai saat tombol "Konfirmasi Kode" ditekan
    }
    @IBOutlet weak var codeVerifikasi: DPOTPView!
    
    var countdownTimer: Timer?
    var remainingTimeInSeconds: Int = 5 * 60 // Waktu verifikasi dalam detik (contoh: 5 menit)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Memulai timer mundur saat tampilan dimuat
        startCountdownTimer()
    }
    
    // Fungsi untuk memulai timer mundur
    func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    // Fungsi yang dipanggil setiap detik untuk memperbarui waktu mundur
    @objc func updateCountdown() {
        guard remainingTimeInSeconds > 0 else {
            // Jika waktu verifikasi habis, hentikan timer dan tampilkan pesan
            countdownTimer?.invalidate()
            waktuVerifikasi.text = "Waktu verifikasi habis"
            return
        }
        
        // Menghitung menit dan detik yang tersisa
        let minutes = remainingTimeInSeconds / 60
        let seconds = remainingTimeInSeconds % 60
        
        // Menampilkan waktu verifikasi yang tersisa dalam format menit:detik
        waktuVerifikasi.text = String(format: "Waktu verifikasi: %02d:%02d", minutes, seconds)
        
        // Mengurangi waktu tersisa setiap detik
        remainingTimeInSeconds -= 1
    }
}
