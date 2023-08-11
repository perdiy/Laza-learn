//
//  AddReviewViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//

import UIKit

class AddReviewViewController: UIViewController {

    @IBOutlet weak var rating: UILabel!
    private let ratingLb: Float = 0.0
    @IBOutlet weak var slider: CustomSlider! {
        didSet {
            slider.sliderHeight = CGFloat(18)
            slider.minimumValue = 0.0
            slider.maximumValue = 5.0
            slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        }
    }
    @IBOutlet weak var viewBack: UIView!

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.value = ratingLb
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }

    @objc func sliderValueChanged(_ sender: CustomSlider) {
        let value = sender.value
        rating.text = String(format: "%.1f", value) // Mengubah teks label rating dengan nilai slider
    }
}
