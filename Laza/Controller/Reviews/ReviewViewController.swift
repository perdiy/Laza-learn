//
//  ReviewViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//


import UIKit
import Cosmos

class ReviewViewController: UIViewController {
    
    var productId: Int = 0
    var viewModel: ReviewViewModel!
    
    @IBOutlet weak var allReviews: UILabel!
    @IBOutlet weak var reviewStar: CosmosView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addReviewsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        if let addReviewsVC = storyboard.instantiateViewController(withIdentifier: "AddReviewViewController") as? AddReviewViewController {
            addReviewsVC.productId = productId
            navigationController?.pushViewController(addReviewsVC, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewStar.rating = 5
        reviewStar.text = ""
        
        let nib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        viewModel = ReviewViewModel() // Buat instance ViewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReviews()
    }
    
    func fetchReviews() {
        viewModel.fetchReviews(productId: productId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.allReviews.text = "\(self.viewModel.totalReviews) Reviews"
                }
            case .failure(let error):
                print("Error fetching reviews: \(error)")
            }
        }
    }
}

extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        
        let review = viewModel.reviews[indexPath.row]
        cell.userName.text = review.fullName
        cell.commentLabel.text = review.comment
        cell.dateLabel.text = review.createdAt
        cell.ratingLabel.text = String(review.rating)
        cell.star.rating = Double(review.rating)
        cell.imgView.loadImageFromURL(url: review.imageUrl)
        
        return cell
    }
}

