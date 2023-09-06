//
//  Date.swift
//  Laza
//
//  Created by Perdi Yansyah on 05/09/23.
//

import Foundation
class DateTimeUtils {
    static let shared = DateTimeUtils()
    
    private let formatter = DateFormatter()
    
    func formatReview(date: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let formattedDate = formatter.date(from: date) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: formattedDate)
        }
        return date
    }
}
