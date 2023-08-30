//
//  UpdateAddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/08/23.
//

import UIKit

class UpdateAddressViewController: UIViewController {

    var addressToUpdate: DataAllAddress? // Address data to be updated
    
    @IBAction func updateBtn(_ sender: Any) {
        updateAddress()
    }
    
    @IBOutlet weak var numberPhoneLb: UITextField!
    @IBOutlet weak var cityLb: UITextField!
    @IBOutlet weak var countryLb: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillAddressInfo()
    }
    
    // Fill the address information in the text fields
    func fillAddressInfo() {
        guard let address = addressToUpdate else {
            return
        }
        
        nameLabel.text = address.receiverName
        countryLb.text = address.country
        cityLb.text = address.city
        numberPhoneLb.text = address.phoneNumber
    }
    
    // Update the address on the server
    func updateAddress() {
        guard let address = addressToUpdate,
              let accessToken = UserDefaults.standard.string(forKey: "userToken") else {
            return
        }
        
        let urlString = "https://lazaapp.shop/address/\(address.id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        
        // Create a dictionary with updated address information
        let updatedAddress: [String: Any] = [
            "receiver_name": nameLabel.text ?? "",
            "country": countryLb.text ?? "",
            "city": cityLb.text ?? "",
            "phone_number": numberPhoneLb.text ?? ""
        ]
        
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
    
    // Show an alert when the address is successfully updated
    func showUpdateSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Address updated successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Pop back to the previous view controller
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}