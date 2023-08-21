//
//  ReviewViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//


import UIKit
import Cosmos
 
class ReviewViewController: UIViewController {
    
    @IBAction func addReviewsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        if let addReviewsVC = storyboard.instantiateViewController(withIdentifier: "AddReviewViewController") as? AddReviewViewController {
            addReviewsVC.productId = productId
            navigationController?.pushViewController(addReviewsVC, animated: true)
        }
    }

    @IBOutlet weak var allReviews: UILabel!
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var reviewStar: CosmosView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var reviews: [Review] = []
    
    var productId: Int = 0
    
    var totalReviews: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inisialisasi bintang ulasan dan tampilan lainnya
        reviewStar.rating = 5
        reviewStar.text = ""
        
        // Daftarkan nib ReviewsTableViewCell untuk tabel
        let nib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Bulatkan sudut viewBack
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Panggil fungsi untuk mengambil ulasan dari API
        fetchReviews()
    }
    
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
                        self.reviews = reviewResponse.data.reviews
                        self.totalReviews = reviewResponse.data.total
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.allReviews.text = "\(self.totalReviews) Reviews"
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}

extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        
        let review = reviews[indexPath.row]
        cell.userName.text = review.fullName
        cell.commentLabel.text = review.comment
        cell.dateLabel.text = review.createdAt
        cell.ratingLabel.text = String(review.rating)
        cell.star.rating = Double(review.rating)
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
