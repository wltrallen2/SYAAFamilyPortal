//
//  Production.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import Foundation

struct Production: IdCodable {
    var id: Int
    var title: String
    var season: String
    var start: Date
    var end: Date
    var rehearsals: [Rehearsal]
    var characters: [Character]
    var castingLinks: [CastingLink]
    
    static let `default` = productionData[0]
}

enum ProductionCodingKeys: CodingKey {
    case id
    case title
    case season
    case start
    case end
    case rehearsals
    case characters
    case casting
}

extension Production: Decodable {
    init(from decoder: Decoder) throws {
        let prodValues = try decoder.container(keyedBy: ProductionCodingKeys.self)
        
        id = try prodValues.decode(Int.self, forKey: .id)
        title = try prodValues.decode(String.self, forKey: .title)
        season = try prodValues.decode(String.self, forKey: .season)
        rehearsals = try prodValues.decode(Array<Rehearsal>.self, forKey: .rehearsals)
        characters = try prodValues.decode(Array<Character>.self, forKey: .characters)
        castingLinks = try prodValues.decode(Array<CastingLink>.self, forKey: .casting)
        
        let startString = try prodValues.decode(String.self, forKey: .start)
        let endString = try prodValues.decode(String.self, forKey: .end)
        
        start = startString.toDateFromFormat("yyyy-MM-dd")!
        end = endString.toDateFromFormat("yyyy-MM-dd")!
    }
}

extension Production: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ProductionCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(season, forKey: .season)
        try container.encode(rehearsals, forKey: .rehearsals)
        try container.encode(characters, forKey: .characters)
        try container.encode(castingLinks, forKey: .casting)
        
        try container.encode(start.dashStyle(), forKey: .start)
        try container.encode(end.dashStyle(), forKey: .end)
    }
}
