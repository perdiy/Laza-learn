//
//  UpdateAddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/08/23.
//

import UIKit

class UpdateAddressViewController: UIViewController {

    // Variabel untuk menyimpan data alamat yang akan diperbarui.
    var addressToUpdate: DataAllAddress?
    
    // Outlets untuk elemen antarmuka pengguna.
    @IBAction func updateBtn(_ sender: Any) {
        updateAddress()
    }
    @IBOutlet weak var numberPhoneLb: UITextField!
    @IBOutlet weak var cityLb: UITextField!
    @IBOutlet weak var countryLb: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var primarySwitch: UISwitch!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mengatur sudut lengkungan dan meng-clip viewBack agar berbentuk bulat.
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Mengisi informasi alamat ke dalam teks field.
        fillAddressInfo()
    }
    
    // Isi informasi alamat ke dalam teks field.
    func fillAddressInfo() {
        guard let address = addressToUpdate else {
            return
        }
        
        nameLabel.text = address.receiverName
        countryLb.text = address.country
        cityLb.text = address.city
        numberPhoneLb.text = address.phoneNumber
        primarySwitch.isOn = address.isPrimary ?? false
    }
    
    // Perbarui alamat di server.
    func updateAddress() {
        guard let address = addressToUpdate,
              let accessToken = KeychainManager.shared.getAccessToken() else {
            return
        }
        
        let urlString = "https://lazaapp.shop/address/\(address.id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        
        // Buat sebuah dictionary dengan informasi alamat yang diperbarui.
        var updatedAddress: [String: Any] = [
            "receiver_name": nameLabel.text ?? "",
            "country": countryLb.text ?? "",
            "city": cityLb.text ?? "",
            "phone_number": numberPhoneLb.text ?? ""
        ]
        updatedAddress["is_primary"] = primarySwitch.isOn
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updatedAddress, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error creating JSON data:", error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error updating address:", error)
                return
            }
            
            DispatchQueue.main.async {
                self?.showUpdateSuccessAlert()
            }
        }.resume()
    }
    
    // Tampilkan peringatan ketika alamat berhasil diperbarui.
    func showUpdateSuccessAlert() {
        let alert = UIAlertController(title: "Sukses", message: "Alamat berhasil diperbarui", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
