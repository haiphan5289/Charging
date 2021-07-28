//
//  AnimationModel.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import Foundation
struct ChargingAnimationModel: Codable {
    let title: String?
    let id: Int?
    let link: [IconModel]?

    enum CodingKeys: String, CodingKey {
        case title
        case id
        case link
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        link = try values.decodeIfPresent([IconModel].self, forKey: .link)
    }
}
