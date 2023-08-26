//
//  ImgCompress.swift
//  Laza
//
//  Created by Perdi Yansyah on 25/08/23.
//

import Foundation
import UIKit

typealias Parameters = [String: String]

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "perdiy.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
