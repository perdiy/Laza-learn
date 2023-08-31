//
//  ListAddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//
 
import UIKit

class ListAddressViewController: UIViewController, UITableViewDataSource {
    
    var viewModel = ListAddressViewModel()
    var addresses: [DataAllAddress] = []
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
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
        fetchAddresses()
    }
    func fetchAddresses() {
            guard let accessToken = UserDefaults.standard.string(forKey: "userToken") else {
                // Handle case when access token is not available
                return
            }
            
            viewModel.fetchAddresses(accessToken: accessToken) { [weak self] error in
                if let error = error {
                    // Handle error, maybe show an alert to the user
                    print("Error fetching addresses:", error)
                } else {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.addresses.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListAddressTableViewCell", for: indexPath) as! ListAddressTableViewCell
            
            let address = viewModel.addresses[indexPath.row]
            
            cell.nameLabel.text = address.receiverName
            cell.countryLabel.text = address.country
            cell.cityLabel.text = address.city
            cell.phoneLabel.text = address.phoneNumber
            
            // Unwrap the optional value address.isPrimary
            if let isPrimary = address.isPrimary {
                cell.circlePrimary.isHidden = !isPrimary
            } else {
                cell.circlePrimary.isHidden = true
            }
            
            return cell
        }
    }

extension ListAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            guard let accessToken = UserDefaults.standard.string(forKey: "userToken") else {
                return
            }
            
            viewModel.deleteAddress(at: indexPath, accessToken: accessToken) { [weak self] error in
                if let error = error {
                    print("Error deleting address:", error)
                } else {
                    DispatchQueue.main.async {
                        self?.viewModel.addresses.remove(at: indexPath.row)

                        // Perform the UI update within a batch update block
                        self?.tableView.performBatchUpdates({
                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                        }, completion: nil)

                        print("Address deleted and table updated")
                    }
                }
            }
        }
    // MARK: - Show Update Address View
    
    func showUpdateAddress(for indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        
        if let updateAddressViewController = storyboard.instantiateViewController(withIdentifier: "UpdateAddressViewController") as? UpdateAddressViewController {
            let addressToUpdate = viewModel.addresses[indexPath.row]
            updateAddressViewController.addressToUpdate = addressToUpdate
            navigationController?.pushViewController(updateAddressViewController, animated: true)
        }
    }
}
