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
    }
    @IBOutlet weak var codeVerifikasi: DPOTPView!
    
    var countdownTimer: Timer?
    var remainingTimeInSeconds: Int = 5 * 60 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCountdownTimer()
    }
    
    func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        guard remainingTimeInSeconds > 0 else {
            countdownTimer?.invalidate()
            waktuVerifikasi.text = "Waktu verifikasi habis"
            return
        }
        
        let minutes = remainingTimeInSeconds / 60
        let seconds = remainingTimeInSeconds % 60
        waktuVerifikasi.text = String(format: "Waktu verifikasi: %02d:%02d", minutes, seconds)
        
        remainingTimeInSeconds -= 1
    }
}

