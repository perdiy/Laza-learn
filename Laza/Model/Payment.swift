//
//  Payment.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/09/23.
//

import Foundation
struct CreditCard : Codable {
    var userId : Int32 = 0
    var cardOwner : String = ""
    var cardNumber : String = ""
    var cardExpMonth : Int16 = 0
    var cardExpYear : Int16 = 0
    var cardCvv : Int16 = 0
}
