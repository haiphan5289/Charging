//
//  NumberExtension.swift
//  Dayshee
//
//  Created by paxcreation on 11/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

extension NSNumber {
    static let formatCurrency = format()
    
    private static func format() -> NumberFormatter {
        let format = NumberFormatter()
        format.locale = Locale(identifier: "vi_VN")
        format.numberStyle = .currency
        format.currencyGroupingSeparator = ","
        format.minimumFractionDigits = 0
        format.maximumFractionDigits = 0
        format.positiveFormat = "#,###\u{00a4}"
        return format
    }
    
    func money() -> String? {
       return NSNumber.formatCurrency.string(from: self)
    }
    
    func percentCharging() -> String? {
        let value = CGFloat(truncating: self)
        let p = Int(value * 100)
        
        return "\(p)%"
    }
    
}

extension Numeric {
    
    var batterCharging: String {
        return (self as? NSNumber)?.percentCharging() ?? ""
    }
    
    var currency: String {
        return (self as? NSNumber)?.money() ?? ""//.currency(withISO3: "VND", placeSymbolFront: false) ?? ""
    }
        
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
extension Int {
    func covertSecondToMinute(seconds: Int32) -> String {
        let minutes = (seconds % 3600) / 60
        let second = (seconds % 3600) % 60
        return "\(minutes):\(second)"
    }
    
    func convertTimeToString(time: Int) -> String{
        switch Int(time) {
        //10
        case let x where x < 10:
            return "00:0\(x)"
            
        // less one minute
        case let x where x >= 10 && x < 60:
            return "00:\(x)"
            
        //less ten minute
        case let x where x >= 60 && x < 600:
            return "0\(Double(x).asString(style: .positional))"
            
        //less one hours
        case let x where x >= 600 && x < 3600:
            return "\(Double(x).asString(style: .positional))"
            
        //less ten hours
        case let x where x >= 3600 && x < 36000:
            return "0\(Double(x).asString(style: .positional))"

        //greater than ten hours
        case let x where x >= 36000:
            return "\(Double(x).asString(style: .positional))"
        default:
            break
        }
        return ""
    }
}
extension Int32 {
    func covertSecondToMinute(seconds: Int32) -> String {
        let minutes = (seconds % 3600) / 60
        let second = (seconds % 3600) % 60
        return "\(minutes):\(second)"
    }
}
extension Double {
    //convert second to Hours
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor) / divisor
    }
    
    func roundTo() -> String {
        let value = self * 100
        let stringValue = String(format: "%.1f", value)
        return stringValue
    }
}
