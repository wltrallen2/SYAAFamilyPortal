//
//  UpdateAdultData.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/18/20.
//

import Foundation

struct UpdateAdultData {
    var adult: Adult
    var userId: Int
    
    init(adult: Adult, user: User) {
        self.adult = adult
        self.userId = user.id
    }
}

enum UpdateAdultCodingKeys: CodingKey {
    case userId
    case personId
    case firstName
    case lastName
    case hasVerified
    case address1
    case address2
    case city
    case state
    case zip
    case phone1
    case phone1Type
    case phone2
    case phone2Type
    case email
    
}

extension UpdateAdultData: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UpdateAdultCodingKeys.self)
                
        try container.encode(userId, forKey: .userId)
        
        try container.encode(adult.person.id, forKey: .personId)
        try container.encode(adult.person.firstName, forKey: .firstName)
        try container.encode(adult.person.lastName, forKey: .lastName)
        try container.encode(adult.person.hasVerified, forKey: .hasVerified)
        
        try container.encode(adult.address1, forKey: .address1)
        try container.encode(adult.address2, forKey: .address2)
        try container.encode(adult.city, forKey: .city)
        try container.encode(adult.state, forKey: .state)
        try container.encode(adult.zip, forKey: .zip)
        
        
        try container.encode(adult.phone1, forKey: .phone1)
        try container.encode(adult.phone1Type, forKey: .phone1Type)
        try container.encode(adult.phone2, forKey: .phone2)
        try container.encode(adult.phone2Type, forKey: .phone2Type)
        try container.encode(adult.email, forKey: .email)
    }
}
