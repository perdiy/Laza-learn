//
//  DetailViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 28/07/23.
//


import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var viewBack: UIView!{
        didSet {
            viewBack.layer.cornerRadius = viewBack.bounds.height / 2
            viewBack.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!

    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Update UI with the product details
        if let product = product {
            titleLabel.text = product.title
            priceLabel.text = "$ \(product.price)"
            descriptionLabel.text = product.description

            if let imageUrl = URL(string: product.image) {
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

    @IBAction func backArrowTapped(_ sender: UIButton) {
        // Use the navigationController to go back to the previous view controller
        navigationController?.popViewController(animated: true)
    }
}
