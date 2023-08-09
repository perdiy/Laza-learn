//
//  ListAddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//

import UIKit

class ListAddressViewController: UIViewController, UITableViewDataSource {
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addAdrsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        if let addressViewController = storyboard.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController {
            navigationController?.pushViewController(addressViewController, animated: true)
        }
    }
    let addresses = [
        Address(name: "Balki", country: "Afrika", city: "New", phone: "123-456-7890", address: "Jl. Utama 123"),
        Address(name: "Ronaldo", country: "Kanada", city: "Toronto", phone: "555-123-4567", address: " Jl. Casablanca Raya Kav. 88 Jakarta Selatan. ")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mengatur corner radius dan memotong sudut dari viewBack
        backView.layer.cornerRadius =  backView.bounds.height / 2.0
        backView.clipsToBounds = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "ListAddressTableViewCell")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAddressTableViewCell", for: indexPath) as! ListAddressTableViewCell
        
        let address = addresses[indexPath.row]
        
        cell.nameLabel.text = address.name
        cell.countryLabel.text = address.country
        cell.cityLabel.text = address.city
        cell.phoneLabel.text = address.phone
        cell.AddressLabel.text = address.address
        
        return cell
    }
    
    struct Address {
        let name: String
        let country: String
        let city: String
        let phone: String
        let address: String
    }
}

extension ListAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
