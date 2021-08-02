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


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ListAnimationModel: Codable {
    let list: [AnimationModel]?
    
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([AnimationModel].self, forKey: .list)
    }
}

// MARK: - Datum
struct AnimationModel: Codable {
    let id: Int?
    let name: String?
    let createDate, writeDate: Int?
    let videos: [Video]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createDate = "create_date"
        case writeDate = "write_date"
        case videos
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        createDate = try values.decodeIfPresent(Int.self, forKey: .createDate)
        writeDate = try values.decodeIfPresent(Int.self, forKey: .writeDate)
        videos = try values.decodeIfPresent([Video].self, forKey: .videos)
    }
}

// MARK: - Video
struct Video: Codable {
    let id: Int?
    let filename: String?
    let image: String?
    let idCategory, createDate, writeDate: Int?

    enum CodingKeys: String, CodingKey {
        case id, filename, image
        case idCategory = "id_category"
        case createDate = "create_date"
        case writeDate = "write_date"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        filename = try values.decodeIfPresent(String.self, forKey: .filename)
        createDate = try values.decodeIfPresent(Int.self, forKey: .createDate)
        writeDate = try values.decodeIfPresent(Int.self, forKey: .writeDate)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        idCategory = try values.decodeIfPresent(Int.self, forKey: .idCategory)
    }
}

struct ListSound: Codable {
    let list: [SoundModel]?
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([SoundModel].self, forKey: .list)
    }
}

// MARK: - Datum
struct SoundModel: Codable {
    let id: Int?
    let filename: String?
    let name: String?
//    let artist: JSONNull?
    let createDate, writeDate: Int?

    enum CodingKeys: String, CodingKey {
        case id, filename, name
//        case artist
        case createDate = "create_date"
        case writeDate = "write_date"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        filename = try values.decodeIfPresent(String.self, forKey: .filename)
        createDate = try values.decodeIfPresent(Int.self, forKey: .createDate)
        writeDate = try values.decodeIfPresent(Int.self, forKey: .writeDate)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
