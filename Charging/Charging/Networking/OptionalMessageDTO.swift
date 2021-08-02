//
//  OptionalMessageDTO.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

public struct OptionalMessageDTO<T: Codable>: Codable {
    public typealias Model = Optional<T>
    public var data: Model?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(T.self, forKey: .data)
    }
}
