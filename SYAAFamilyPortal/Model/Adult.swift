//
//  Adult.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/21/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

enum PhoneType: Int, Codable {
    
    case Cell
    case Work
    case Landline
    case NilValue
    
    var description: String {
        switch self {
        case .Cell:
            return "Cell"
        case .Work:
            return "Work"
        case .Landline:
            return "Landline"
        default:
            return ""
        }
    }
}

struct Adult: Comparable {
    var person: Person
    var addressId: Int
    var address1: String
    var address2: String?
    var city: String
    var state: String
    var zip: String
    var phone1: String
    var phone1Type: PhoneType
    var phone2: String?
    var phone2Type: PhoneType?
    var email: String
        
    static func == (a: Adult, b: Adult) -> Bool {
        return a.person == b.person
            && a.address1 == b.address1
            && a.address2 == b.address2
            && a.city == b.city
            && a.state == b.state
            && a.zip == b.zip
            && a.phone1 == b.phone1
            && a.phone1Type == b.phone1Type
            && a.phone2 == b.phone2
            && a.phone2Type == b.phone2Type
            && a.email == b.email
    }
    
    static func < (a: Adult, b: Adult) -> Bool {
        return a.person < b.person
    }
    
    static let `default` = adultData[0]
}

enum AdultCodingKeys: CodingKey {
    case person
    case address
    case phone1
    case phone1Type
    case phone2
    case phone2Type
    case email
}

enum AddressCodingKeys: CodingKey {
    case id
    case address1
    case address2
    case city
}

enum CityCodingKeys: CodingKey {
    case city
    case state
    case zip
}

extension Adult: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AdultCodingKeys.self)
        
        person = try values.decode(Person.self, forKey: .person)
        phone1 = try values.decode(String.self, forKey: .phone1)
        phone2 = try values.decodeIfPresent(String.self, forKey: .phone2)
        email = try values.decode(String.self, forKey: .email)
        
        phone1Type = try values.decode(PhoneType.self, forKey: .phone1Type)
        phone2Type = try values.decodeIfPresent(PhoneType.self, forKey: .phone2Type)

        let addressValues = try values.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        addressId = try addressValues.decode(Int.self, forKey: .id)
        address1 = try addressValues.decode(String.self, forKey: .address1)
        address2 = try addressValues.decodeIfPresent(String.self, forKey: .address2)
        
        let cityValues = try addressValues.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)
        city = try cityValues.decode(String.self, forKey: .city)
        state = try cityValues.decode(String.self, forKey: .state)
        zip = try cityValues.decode(String.self, forKey: .zip)
    }
}

extension Adult: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AdultCodingKeys.self)
        
        try container.encode(person, forKey: .person)
        
        var addressContainer = container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        try addressContainer.encode(addressId, forKey: .id)
        try addressContainer.encode(address1, forKey: .address1)
        try addressContainer.encode(address2, forKey: .address2)
        
        var cityContainer = addressContainer.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)
        try cityContainer.encode(city, forKey: .city)
        try cityContainer.encode(state, forKey: .state)
        try cityContainer.encode(zip, forKey: .zip)
        
        try container.encode(phone1, forKey: .phone1)
        try container.encode(phone1Type, forKey: .phone1Type)
        try container.encode(phone2, forKey: .phone2)
        try container.encode(phone2Type, forKey: .phone2Type)
        try container.encode(email, forKey: .email)
    }
}
