//
//  AddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class AddressViewController: UIViewController {
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var cityTf: UITextField!
    @IBOutlet weak var countryTf: UITextField!
    @IBOutlet weak var primarySwitch: UISwitch!
    @IBOutlet weak var viewBack: UIView!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private let addressViewModel = AddressViewModel() // Initialize the AddressViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    @IBAction func saveAddress(_ sender: Any) {
        // Mengambil nilai dari UITextField dan userToken
        guard let name = nameTf.text,
              let phone = phoneTf.text,
              let city = cityTf.text,
              let country = countryTf.text,
              let userToken = KeychainManager.shared.getAccessToken() else {
            return
        }
        
        let isPrimary = primarySwitch.isOn
        
        // [weak self] Ini akan membantu menghindari potensi masalah seperti strong reference cycle.
        // Call the saveAddress method from the AddressViewModel
        addressViewModel.saveAddress(name: name, phone: phone, city: city, country: country, isPrimary: isPrimary, userToken: userToken) { [weak self] success, error in
            if success {
                // Address added successfully
                print("Address added successfully")
                
                DispatchQueue.main.async {
                    // Navigate back to the previous view controller
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                // Handle error
                print("Error adding address: \(error?.localizedDescription ?? "Unknown Error")")
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
