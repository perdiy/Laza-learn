//
//  AddReviewViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var slider: CustomSlider! {
        didSet {
            slider.sliderHeight = CGFloat(18)
            slider.minimumValue = 0.0
            slider.maximumValue = 5.0
            slider.value = viewModel.initialRating
            slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var viewBack: UIView!
    
    var productId: Int = 0
    var userToken: String {
        return KeychainManager.shared.getAccessToken() ?? ""
    }

    
    var viewModel = AddReviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.value = viewModel.initialRating
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    @objc func sliderValueChanged(_ sender: CustomSlider) {
        let value = round(sender.value * 2) / 2
        slider.value = value
        rating.text = String(format: "%.1f", value)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addReviewButtonTapped(_ sender: UIButton) {
        uploadReview()
    }
    
    private func uploadReview() {
        viewModel.uploadReview(productId: productId, token: userToken, rating: slider.value, comment: comment.text ?? "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                print("Review berhasil dikirim!")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: false)
                }
            case .failure(let error):
                print("Error mengirim review: \(error)")
            }
        }
    }
}
