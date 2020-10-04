//
//  Person.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/21/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import Foundation

struct Person: Comparable, IdCodable {
    var id: Int
    var firstName: String
    var lastName: String
    var adult: Adult?
    var student: Student?
    var hasVerified: Bool
    
    mutating func setAdult(_ adult: Adult) {
        self.adult = adult
    }
    
    static func == (a: Person, b: Person) -> Bool {
        return a.id == b.id
            && a.firstName == b.firstName
            && a.lastName == b.lastName
            && (a.adult == b.adult || a.student == b.student)
    }
    
    static func < (a: Person, b: Person) -> Bool {
        return a.firstName < b.firstName
            || (a.firstName == b.lastName && a.lastName < b.lastName)
    }
    
    static let `default` = personData[0]
}

enum PersonCodingKeys: CodingKey {
    case id
    case firstName
    case lastName
    case adult
    case student
    case hasVerified
}

extension Person: Decodable {
    init(from decoder: Decoder) throws {
        let personValues = try decoder.container(keyedBy: PersonCodingKeys.self)
        
        id = try personValues.decode(Int.self, forKey: .id)
        firstName = try personValues.decode(String.self, forKey: .firstName)
        lastName = try personValues.decode(String.self, forKey: .lastName)
        hasVerified = try personValues.decode(Bool.self, forKey: .hasVerified)
        
        adult = try personValues.decodeIfPresent(Adult.self, forKey: .adult)
        student = try personValues.decodeIfPresent(Student.self, forKey: .student)
    }
}


