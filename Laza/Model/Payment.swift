//
//  Payment.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/09/23.
//

import Foundation
struct CreditCard : Codable {
    var cardOwner : String = ""
    var cardNumber : String = ""
    var cardExpMonth : String = ""
    var cardExpYear : String = ""
    var cardCvv : String = ""
}
