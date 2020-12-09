//
//  RepoOWner.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import Foundation

struct RepoDetails: Codable {
    // MARK: - Properties
    let avatarUrl: String
    let name: String
    let created_at: String

    // MARK: - Codable
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case name = "name"
        case created_at = "created_at"


    }
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        self.name = try container.decode(String.self, forKey: .name)
        print(name)
        self.created_at = try container.decode(String.self, forKey: .created_at)


    }
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(name, forKey: .name)
        try container.encode(created_at, forKey: .created_at)

    }
}
