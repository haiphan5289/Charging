//
//  URL+Extension.swift
//  Audio
//
//  Created by paxcreation on 4/12/21.
//

import Foundation
import UIKit

extension URL {
    func getNameAudio() -> String {
        let lastPath = self.lastPathComponent
        let endIndex = lastPath.index(lastPath.endIndex, offsetBy: -4)
        let name = String(lastPath.prefix(upTo: endIndex))
        return name
    }
}
