//
//  NSDecimalNumber.swift
//  Charging
//
//  Created by haiphan on 04/08/2021.
//

import Foundation

extension NSDecimalNumber {
    func converString(produceID: ProductID) -> String {
        return "$\(self) /\(produceID.text)"
    }
}
