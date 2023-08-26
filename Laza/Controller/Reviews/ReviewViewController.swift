//
//  ReviewViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//


import UIKit
import Cosmos

class ReviewViewController: UIViewController {
    
    // Variabel untuk menyimpan data ulasan
    var reviews: [Review] = [] // Array untuk menyimpan data ulasan
    var productId: Int = 0 // ID produk yang akan ditampilkan ulasannya
    var totalReviews: Int = 0 // Jumlah total ulasan
    
    // Tombol untuk menambahkan ulasan baru
    @IBAction func addReviewsBtn(_ sender: Any) {
        // Pindah ke halaman tambah ulasan
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        if let addReviewsVC = storyboard.instantiateViewController(withIdentifier: "AddReviewViewController") as? AddReviewViewController {
            addReviewsVC.productId = productId
            navigationController?.pushViewController(addReviewsVC, animated: true)
        }
    }
    
    // Teks untuk menampilkan total ulasan
    @IBOutlet weak var allReviews: UILabel!
    
    // Tombol untuk kembali ke halaman sebelumnya
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // View yang mengandung bintang ulasan
    @IBOutlet weak var reviewStar: CosmosView!
    
    // Tampilan untuk tombol kembali
    @IBOutlet weak var viewBack: UIView!
    
    // Tabel untuk menampilkan daftar ulasan
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inisialisasi nilai bintang ulasan dan tampilan lainnya
        reviewStar.rating = 5 // Set nilai rating bintang ulasan
        reviewStar.text = "" // Set teks kosong pada bintang ulasan
        
        // Daftarkan nib ReviewsTableViewCell untuk digunakan pada tabel
        let nib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Bulatkan sudut dari viewBack
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Panggil fungsi untuk mengambil ulasan dari API
        fetchReviews()
    }
    
    // Fungsi untuk mengambil data ulasan dari API
    func fetchReviews() {
        let urlString = "https://lazaapp.shop/products/\(productId)/reviews"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching reviews: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let reviewResponse = try decoder.decode(ReviewResponse.self, from: data)
                        self.reviews = reviewResponse.data.reviews // Simpan data ulasan dari response ke dalam array reviews
                        self.totalReviews = reviewResponse.data.total // Simpan jumlah total ulasan
                        DispatchQueue.main.async {
                            self.tableView.reloadData() // Perbarui tampilan tabel
                            self.allReviews.text = "\(self.totalReviews) Reviews" // Tampilkan total ulasan pada label
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}

// Implementasi delegate dan datasource untuk tabel ulasan
extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count // Jumlah baris tabel sesuai dengan jumlah ulasan
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        
        let review = reviews[indexPath.row] // Ambil data ulasan sesuai dengan indeks baris
        cell.userName.text = review.fullName // Tampilkan nama pengguna
        cell.commentLabel.text = review.comment // Tampilkan komentar ulasan
        cell.dateLabel.text = review.createdAt // Tampilkan tanggal ulasan
        cell.ratingLabel.text = String(review.rating) // Tampilkan nilai rating
        cell.star.rating = Double(review.rating) // Set nilai rating bintang ulasan
        
        // Muat gambar ulasan dari URL jika ada
        if let imageUrl = URL(string: review.imageUrl) {  
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        cell.imgView.image = UIImage(data: data)
                    }
                }
            }
        }
        return cell
    }
}
