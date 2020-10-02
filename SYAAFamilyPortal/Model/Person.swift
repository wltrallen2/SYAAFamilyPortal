//
//  Person.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/21/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import Foundation

struct Person: Codable, Comparable {
    var id: Int
    var firstName: String
    var lastName: String
    var hasVerified: Bool
    
    static func == (a: Person, b: Person) -> Bool {
        return a.id == b.id
            && a.firstName == b.firstName
            && a.lastName == b.lastName
    }
    
    static func < (a: Person, b: Person) -> Bool {
        return a.firstName < b.firstName
            || (a.firstName == b.lastName && a.lastName < b.lastName)
    }
}

// TODO: Refractor code so that person has type (adult, student, teacher)?
