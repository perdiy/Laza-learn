//
//  ViewBack.swift
//  Laza
//
//  Created by Perdi Yansyah on 25/08/23.
//

import Foundation
import UIKit

extension UIView {
    func applyCircularButtonStyle() {
        layer.cornerRadius = bounds.height / 2.0
        clipsToBounds = true
    }

    func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }
}
