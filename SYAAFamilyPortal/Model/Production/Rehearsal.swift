//
//  Rehearsal.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import Foundation

struct Rehearsal: IdCodable {
    var id: Int
    var productionId: Int
    var start: Date
    var end: Date
    var description: String
    var characterIds: [Int]
}

enum RehearsalCodingKeys: CodingKey {
    case id
    case productionId
    case start
    case end
    case description
    case characterIds
}

extension Rehearsal: Decodable {
    init(from decoder: Decoder) throws {
        let rehearsalValues = try decoder.container(keyedBy: RehearsalCodingKeys.self)
        
        id = try rehearsalValues.decode(Int.self, forKey: .id)
        productionId = try rehearsalValues.decode((Int.self), forKey: .productionId)
        description = try rehearsalValues.decode(String.self, forKey: .description)
        characterIds = try rehearsalValues.decode(Array<Int>.self, forKey: .characterIds)
        
        let startString = try rehearsalValues.decode(String.self, forKey: .start)
        let endString = try rehearsalValues.decode(String.self, forKey: .end)
        
        start = startString.toDateFromFormat("yyyy-MM-dd HH:mm:ss")!
        end = endString.toDateFromFormat("yyyy-MM-dd HH:mm:ss")!
    }
}

extension Rehearsal: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RehearsalCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(productionId, forKey: .productionId)
        try container.encode(description, forKey: .description)
        try container.encode(characterIds, forKey: .characterIds)
        
        let df = "yyyy-MM-dd HH:mm:ss"
        try container.encode(start.toStringWithFormat(df), forKey: .start)
        try container.encode(end.toStringWithFormat(df), forKey: .end)
    }
}
