//
//  AddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//
 
import UIKit

class AddressViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var cityTf: UITextField!
    @IBOutlet weak var countryTf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = backView.bounds.height / 2.0
        backView.clipsToBounds = true
    }

    @IBAction func saveAddress(_ sender: Any) {
        guard let name = nameTf.text,
              let phone = phoneTf.text,
              let city = cityTf.text,
              let country = countryTf.text,
              let userToken = UserDefaults.standard.string(forKey: "userToken") else {
            // Handle missing values or user token
            return
        }
        
        let apiURLString = "https://lazaapp.shop/address"
        
        guard let apiURL = URL(string: apiURLString) else {
            // Handle invalid API URL
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newAddress = [
            "receiver_name": name,
            "phone_number": phone,
            "city": city,
            "country": country
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: newAddress, options: [])
            request.httpBody = jsonData
        } catch {
            // Handle JSON serialization error
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
                // Handle response and error
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        // Successful response, address added
                        print("Address added successfully")
                        
                        DispatchQueue.main.async {
                            // Navigate back to the previous view controller
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        // Handle error response
                        print("Error response: \(httpResponse.statusCode)")
                    }
                }
            }
            
            task.resume()
        }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
