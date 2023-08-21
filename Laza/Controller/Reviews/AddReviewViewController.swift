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
    private let ratingLb: Float = 0.0
    @IBOutlet weak var slider: CustomSlider! {
        didSet {
            slider.sliderHeight = CGFloat(18)
            slider.minimumValue = 0.0
            slider.maximumValue = 5.0
            slider.value = ratingLb
            slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        }
    }
    @IBOutlet weak var viewBack: UIView!
    
    var productId: Int = 0
    var userToken: String {
        return UserDefaults.standard.string(forKey: "userToken") ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.value = ratingLb
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
        // Prepare the request
        guard let url = URL(string: "https://lazaapp.shop/products/\(productId)/reviews") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(userToken)", forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the review data
        let ratingValue = round(slider.value * 2) / 2
        let commentText = comment.text ?? ""
        let reviewData: [String: Any] = [
            "rating": ratingValue,
            "comment": commentText

        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reviewData, options: [])
        } catch {
            print("Error serializing review data: \(error)")
            return
        }
        
        // Perform the API request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error submitting review: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    // Review submitted successfully
                    print("Review submitted successfully!")
                    
                    // Navigate to ReviewViewController on the main thread
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: false)
                    }
                } else {
                    // Handle other status codes if needed
                    print("Error submitting review: Status code \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
