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
    var paths: [String: String]
    
    func path(_ apiPath: APIPath) -> String {
        return paths[apiPath.rawValue]! // FIXME: For safety, how would I handle this with optional unwrapping instead of forced unwrapping, even though this should never happen?
    }
}

enum APIPath: String, Codable {
    case VerifyUser
    case CreateUser
    case PasswordReset
    case LinkUser
    case SelectUser
    case UpdateUser
    case UpdateAdult
    case UpdateStudent
    case SelectFamily
    case SelectUpcomingProductions
    case SelectAllStudents
    case SelectUpcomingConflicts
}

enum APICodingKeys: CodingKey {
    case APIKey
    case APIPrefix_Local
    case APIPrefix_Remote
    case Paths
}

extension API: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: APICodingKeys.self)
        
        key = try values.decode(String.self, forKey: .APIKey)
        prefixLocal = try values.decode(String.self, forKey: .APIPrefix_Local)
        prefixRemote = try values.decode(String.self, forKey: .APIPrefix_Remote)
        paths = try values.decode([String:String].self, forKey: .Paths)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: APICodingKeys.self)
        
        try container.encode(key, forKey: .APIKey)
        try container.encode(prefixLocal, forKey: .APIPrefix_Local)
        try container.encode(prefixRemote, forKey: .APIPrefix_Remote)
        try container.encode(paths, forKey: .Paths)
    }
}
