//
//  Resp.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import Foundation

struct Repository: Codable{
    // MARK: - Properties
    var name: String
    let url: String

    // MARK: - Codable
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case owner = "owner"
        case name = "name"
        case url = "url"

    }
    // Decoding

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let owner = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)
        url = try owner.decode(String.self, forKey: .url)

    }
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var owner = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)

        try owner.encode(url, forKey: .url)

    }

}

