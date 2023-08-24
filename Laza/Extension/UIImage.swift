//
//  UIImage.swift
//  Laza
//
//  Created by Perdi Yansyah on 24/08/23.
//

import Foundation
import UIKit
extension UIImageView {
    func loadImageFromURL(url: String) {
        guard let imageURL = URL(string: url) else {
            print("Invalid URL for image")
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
