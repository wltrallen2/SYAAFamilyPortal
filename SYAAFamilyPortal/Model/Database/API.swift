//
//  API.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/17/20.
//

import Foundation

struct API {
    var key: String
    var prefixLocal: String
    var prefixRemote: String
}

enum APICodingKeys: CodingKey {
    case APIKey
    case APIPrefix_Local
    case APIPrefix_Remote
}

extension API: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: APICodingKeys.self)
        
        key = try values.decode(String.self, forKey: .APIKey)
        prefixLocal = try values.decode(String.self, forKey: .APIPrefix_Local)
        prefixRemote = try values.decode(String.self, forKey: .APIPrefix_Remote)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: APICodingKeys.self)
        
        try container.encode(key, forKey: .APIKey)
        try container.encode(prefixLocal, forKey: .APIPrefix_Local)
        try container.encode(prefixRemote, forKey: .APIPrefix_Remote)
    }
}
