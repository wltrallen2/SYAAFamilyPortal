//
//  Character.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import Foundation

struct Character: IdCodable, Hashable, Comparable {
    var id: Int
    var productionId: Int
    var name: String
    
    static func < (lhs: Character, rhs: Character) -> Bool {
        lhs.id < rhs.id
    }
}
