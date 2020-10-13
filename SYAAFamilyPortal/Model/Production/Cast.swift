//
//  Cast.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import Foundation

struct Cast: IdCodable, Equatable {
    var id: Int
    var student: Student
    var character: Character
    var castName: String
}
