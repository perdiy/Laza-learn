//
//  ListAddressViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 09/08/23.
//
 
import UIKit

// Protokol yang digunakan untuk mengirim pemilihan alamat dari ListAddressViewController ke objek lain.
protocol chooseAddressProtocol: AnyObject {
    func didSelectAddress(country: String, city: String, addressId: Int)
}

// Kelas ListAddressViewController, turunan dari UIViewController dan mengadopsi UITableViewDataSource.
class ListAddressViewController: UIViewController, UITableViewDataSource {
    
    // ViewModel yang digunakan untuk mengelola data alamat.
    var viewModel = ListAddressViewModel()
    
    // Daftar alamat yang akan ditampilkan di tabel.
    var addresses: [DataAllAddress] = []
    
    // Delegat untuk protokol chooseAddressProtocol, digunakan untuk mengirim pemilihan alamat.
    weak var delegate: chooseAddressProtocol?

    // Outlets ke elemen antarmuka pengguna.
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLb: UILabel!
    
    // Tombol kembali untuk kembali ke layar sebelumnya.
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Tombol untuk menambahkan alamat baru.
    @IBAction func addAddress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        if let addressViewController = storyboard.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController {
            navigationController?.pushViewController(addressViewController, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mengatur corner radius dan meng-clip viewBack agar berbentuk bulat.
        backView.layer.cornerRadius = backView.bounds.height / 2.0
        backView.clipsToBounds = true
        
        // Mengatur delegat dan sumber data tabel.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Mendaftarkan nib sel untuk digunakan dalam tabel.
        tableView.register(UINib(nibName: "ListAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "ListAddressTableViewCell")
        
        emptyLb.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Memuat alamat saat tampilan akan muncul.
        fetchAddresses()
    }
    
    // Fungsi untuk mengambil daftar alamat dari ViewModel.
    func fetchAddresses() {
        viewModel.fetchAddresses { [weak self] error in
            if let error = error {
                // Menghandle kesalahan, misalnya menampilkan pesan kesalahan.
                print("Error fetching addresses:", error)
            } else {
                // Memperbarui tampilan jika berhasil mengambil alamat.
                DispatchQueue.main.async {
                    // Me-reload data tabel atau melakukan tindakan lain yang diperlukan.
                    self?.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addresses.count == 0 {
            emptyLb.isHidden = false
        } else {
            emptyLb.isHidden = true
        }
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Mendapatkan sel tabel yang sesuai dan mengisi data alamat ke dalamnya.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAddressTableViewCell", for: indexPath) as! ListAddressTableViewCell
        let address = viewModel.addresses[indexPath.row]
        cell.nameLabel.text = address.receiverName
        cell.countryLabel.text = address.country
        cell.cityLabel.text = address.city
        cell.phoneLabel.text = address.phoneNumber
        
        // Mengatur tampilan ikon "isPrimary" tergantung pada apakah alamat tersebut adalah alamat utama.
        if let isPrimary = address.isPrimary {
            cell.circlePrimary.isHidden = !isPrimary
        } else {
            cell.circlePrimary.isHidden = true
        }
        
        return cell
    }
}

// Ekstensi ListAddressViewController yang mengadopsi UITableViewDelegate.
extension ListAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Mengatur tinggi baris tabel secara otomatis.
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Meng-handle pemilihan alamat dan mengirimkannya melalui delegat.
        let address = viewModel.addresses[indexPath.row]
        delegate?.didSelectAddress(country: address.country, city: address.city, addressId: address.id)
        print("dapet nih bang: \(address)")
        self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Meng-handle aksi penggeseran (swipe) untuk menghapus dan memperbarui alamat.
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
        // Meng-handle penghapusan alamat dan memperbarui tampilan tabel.
        guard KeychainManager.shared.getAccessToken() != nil else {
            return
        }
        
        viewModel.deleteAddress(at: indexPath) { [weak self] error in
            if let error = error {
                print("Error deleting address:", error)
            } else {
                DispatchQueue.main.async {
                    self?.viewModel.addresses.remove(at: indexPath.row)

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
