//
//  ReviewViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//
import UIKit

class ReviewViewController: UIViewController {
    
    // viewback
    @IBOutlet weak var viewBack: UIView!
   
    // back button
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // navigation to AddReviewsViewController
    @IBAction func addReviewBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        if let addReviewsVC = storyboard.instantiateViewController(withIdentifier: "AddReviewViewController") as? AddReviewViewController {
            self.navigationController?.pushViewController(addReviewsVC, animated: true)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register ReviewsTableViewCell.xib to the table view
        let nib = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
}

extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        
        cell.userName.text = "John Doe"
        cell.commentLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        
        return cell
    }
}
