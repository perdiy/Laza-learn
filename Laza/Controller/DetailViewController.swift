//
//  DetailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//

import UIKit

class DetailViewController: UIViewController {

    // IBOutlet connections for UI elements in the DetailViewController (if any)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!

    var product: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Update UI with the product details
        if let product = product,
           let title = product["title"] as? String,
           let price = product["price"] as? Double,
           let description = product["description"] as? String,
           let imageString = product["image"] as? String,
           let imageUrl = URL(string: imageString) {

            titleLabel.text = title
            priceLabel.text = "$ \(price)"
            descriptionLabel.text = description

            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = image
                    }
                }
            }.resume()
        }
    }
}

