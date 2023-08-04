//
//  AddReviewViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    @IBOutlet weak var slider: CustomSlider! {
        didSet {
            slider.sliderHeight = CGFloat(18)
        }
    }
    @IBOutlet weak var viewBack: UIView!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
    }
    
    
}

