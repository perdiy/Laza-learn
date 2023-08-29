//
//  ListAddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//
 
import UIKit

class ListAddressViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var addresses: [DataAllAddress] = [] // Array to store fetched addresses
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addAddress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil) // Ganti "Main" dengan nama storyboard Anda
        if let addressViewController = storyboard.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController {
            navigationController?.pushViewController(addressViewController, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set corner radius and clip the viewBack
        backView.layer.cornerRadius = backView.bounds.height / 2.0
        backView.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register the cell nib
        tableView.register(UINib(nibName: "ListAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "ListAddressTableViewCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch addresses from the API
        fetchAddresses()
    }
    
    // MARK: - Fetch Addresses
    func fetchAddresses() {
        guard let accessToken = UserDefaults.standard.string(forKey: "userToken") else {
            // Handle case when access token is not available
            return
        }
        
        let urlString = "https://lazaapp.shop/address"
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        
        print("Fetching addresses...")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching addresses:", error)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let addressResponse = try JSONDecoder().decode(AllAddress.self, from: data)
                if let addresses = addressResponse.data {
                    DispatchQueue.main.async {
                        self?.addresses = addresses
                        self?.tableView.reloadData()
                        print("Addresses fetched and table reloaded")
                    }
                }
            } catch let error {
                print("Error decoding data:", error)
            }
        }.resume()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAddressTableViewCell", for: indexPath) as! ListAddressTableViewCell
        
        let address = addresses[indexPath.row]
         
        cell.nameLabel.text = address.receiverName
        cell.countryLabel.text = address.country
        cell.cityLabel.text = address.city
        cell.phoneLabel.text = address.phoneNumber
        // cell.AddressLabel.text = address.user.fullName
        
        return cell
    }
}

extension ListAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedAddress = addresses[indexPath.row]
           
           // Instantiate the CartViewController from storyboard
           guard let cartViewController = UIStoryboard(name: "TabBar", bundle: nil)
               .instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
               return
           }
           
           // Pass the selected address to the CartViewController
           cartViewController.selectedAddress = selectedAddress
           
           // Present the CartViewController
           self.navigationController?.pushViewController(cartViewController, animated: true)
       }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteAddress(at: indexPath)
            completionHandler(true)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { [weak self] (action, view, completionHandler) in
            self?.showUpdateAddress(for: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        return configuration
    }
    
    // MARK: - Delete Address
    
    func deleteAddress(at indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        
        guard let accessToken = UserDefaults.standard.string(forKey: "userToken") else {
            // Handle case when access token is not available
            return
        }
        
        let urlString = "https://lazaapp.shop/address/\(address.id)"
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        
        print("Deleting address...")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error deleting address:", error)
                return
            }
            
            DispatchQueue.main.async {
                self?.addresses.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Address deleted and table updated")
            }
        }.resume()
    }
    
    // MARK: - Show Update Address View
    
    func showUpdateAddress(for indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil) // Ganti "Main" dengan nama storyboard Anda
        if let updateAddressViewController = storyboard.instantiateViewController(withIdentifier: "UpdateAddressViewController") as? UpdateAddressViewController {
            updateAddressViewController.addressToUpdate = addresses[indexPath.row]
            navigationController?.pushViewController(updateAddressViewController, animated: true)
        }
    }
}
