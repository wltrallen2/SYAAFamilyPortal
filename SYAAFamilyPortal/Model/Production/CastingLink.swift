//
//  CastingLink.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import Foundation

struct CastingLink: IdCodable, Equatable {
    var id: Int
    var studentId: Int
    var characterId: Int
    var castName: String
}
