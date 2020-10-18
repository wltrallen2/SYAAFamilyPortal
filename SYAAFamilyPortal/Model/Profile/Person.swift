//
//  Person.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/21/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import Foundation

protocol Personable {
    var id: Int { get set }
    var person: Person { get set }
}

struct Person: Codable, Comparable, IdCodable {
    var id: Int
    var firstName: String
    var lastName: String
    var hasVerified: Bool
    
    var fullName: String {
        firstName + " " + lastName
    }
            
    static func == (a: Person, b: Person) -> Bool {
        return a.id == b.id
            && a.firstName == b.firstName
            && a.lastName == b.lastName
            && a.hasVerified == b.hasVerified
    }
    
    static func < (a: Person, b: Person) -> Bool {
        return a.firstName < b.firstName
            || (a.firstName == b.lastName && a.lastName < b.lastName)
    }
}

enum PersonCodingKeys: CodingKey {
    case id
    case firstName
    case lastName
    case hasVerified
}

