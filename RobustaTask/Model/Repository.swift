//
//  Resp.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import Foundation

struct Repository: Codable{
    // MARK: - Properties
    let name: String
//    let descrption: String
//    let privacy: Bool
    let ownerUrl: String

    // MARK: - Codable
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case owner = "owner"
        case name = "name"
        case description = "description"
        case privacy = "private"
        case ownerUrl = "url"
    }
    // Decoding

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
//        self.descrption = try container.decode(String.self, forKey: .description)
//        self.privacy = try container.decode(Bool.self, forKey: .privacy)
        let owner = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)
        ownerUrl = try owner.decode(String.self, forKey: .ownerUrl)
    }
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
//        try container.encode(descrption, forKey: .description)
//        try container.encode(privacy, forKey: .privacy)
        var owner = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)

        try owner.encode(ownerUrl, forKey: .ownerUrl)

    }

}

