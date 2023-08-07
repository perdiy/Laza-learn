//
//  extension.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//

import UIKit

extension UIView {
    
    func addShadow(color: UIColor, widht: CGFloat, text: UITextField) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y:text.frame.height + 10, width: self.frame.size.width, height: widht)
        self.layer.addSublayer(border)
    }
    @IBInspectable var cornerRasius: CGFloat {
        get { return self.cornerRasius}
        set { self.layer.cornerRadius = newValue}
    }
}


