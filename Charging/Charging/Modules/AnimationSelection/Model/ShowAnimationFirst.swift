//
//  ShowAnimationFirst.swift
//  Charging
//
//  Created by haiphan on 04/08/2021.
//

import Foundation

struct ShowAnimationFirstModel: Codable {
    let isFirst: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isFirst
    }
    
}
