//
//  NSDecimalNumber.swift
//  Charging
//
//  Created by haiphan on 04/08/2021.
//

import Foundation

extension NSDecimalNumber {
    func converString(produceID: ProductID) -> String {
        let int = Double(Double(truncating: self) * 100) / 100
        let stringValue = String(format: "%.2f", int)
        return "$\(stringValue) /\(produceID.text)"
    }
}
