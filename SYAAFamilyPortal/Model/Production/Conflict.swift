//
//  Conflict.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import Foundation

enum ConflictType: String {
    case Conflict = "conflict"
    case ArriveLate = "arrive_late"
    case LeaveEarly = "leave_early"
}

struct Conflict: IdCodable {
    var id: Int
    var rehearsalId: Int
    var studentId: Int
    var type: ConflictType
}

enum ConflictCodingKeys: CodingKey {
    case id
    case rehearsalId
    case studentId
    case type
}

extension Conflict: Decodable {
    init(from decoder: Decoder) throws {
        let conflictValues = try decoder.container(keyedBy: ConflictCodingKeys.self)

        id = try conflictValues.decode(Int.self, forKey: .id)
        rehearsalId = try conflictValues.decode(Int.self, forKey: .rehearsalId)
        studentId = try conflictValues.decode(Int.self, forKey: .studentId)
        
        let typeString = try conflictValues.decode(String.self, forKey: .type)
        type = ConflictType.init(rawValue: typeString)!
    }
}

extension Conflict: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConflictCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(rehearsalId, forKey: .rehearsalId)
        try container.encode(studentId, forKey: .studentId)
        try container.encode(type.rawValue, forKey: .type)
    }
}
