//
//  Student.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/2/20.
//

import Foundation
import SwiftUI

let timeInterval = TimeInterval(-60 * 60 * 24 * 365 * 6)

struct Student: Equatable, IdCodable, Personable {
    var id: Int
    var person: Person
    var birthdate: Date
    var school: String?
    var teacher: String?
    var currentGrade: Int
    var expectedGraduation: String
    var notes: String
    var profileColor: Color
    var headshotURL: URL?
    var auditionVideoURL: URL?
        
    static func == (a: Student, b: Student) -> Bool {
        return a.id == b.id
            && a.person == b.person
            && a.birthdate == b.birthdate
            && a.school == b.school
            && a.teacher == b.teacher
            && a.currentGrade == b.currentGrade
            && a.expectedGraduation == b.expectedGraduation
            && a.notes == b.notes
            && a.profileColor == b.profileColor
            && a.headshotURL == b.headshotURL
            && a.auditionVideoURL == b.auditionVideoURL
    }
    
    static let `default` = Student(id: 2, person: Person(id: 2, firstName: "Jane", lastName: "Doe", hasVerified: true), birthdate: Date(timeIntervalSinceNow: TimeInterval(-60 * 60 * 24 * 365 * 6)), school: "May-Allen Academy", teacher: nil, currentGrade: 2, expectedGraduation: "2024", notes: "Such an awesome kiddo", profileColor: Color(red: 255/255, green: 182/255, blue: 203/255, opacity: 1.0), headshotURL: nil, auditionVideoURL: nil)
}

enum StudentCodingKeys: CodingKey {
    case id
    case person
    case birthdate
    case school
    case teacher
    case currentGrade
    case expectedGraduation
    case notes
    case profileColor
    case headshotURL
    case auditionVideoURL
}

extension Student: Decodable {
    init(from decoder: Decoder) throws {
        let studentValues = try decoder.container(keyedBy: StudentCodingKeys.self)
        
        person = try studentValues.decode(Person.self, forKey: .person)
        id = person.id
        
        school = try studentValues.decodeIfPresent(String.self, forKey: .school)
        teacher = try studentValues.decodeIfPresent(String.self, forKey: .teacher)
        currentGrade = try studentValues.decode(Int.self, forKey: .currentGrade)
        notes = try studentValues.decode(String.self, forKey: .notes)
        
        let birthdateString = try studentValues.decode(String.self, forKey: .birthdate)
        birthdate = birthdateString.toDateFromFormat("yyyy-MM-dd") ?? Date()
        
        expectedGraduation = try studentValues.decode(String.self, forKey: .expectedGraduation)
        
        let colorString = try studentValues.decode(String.self, forKey: .profileColor)
        profileColor = Color.init(hex: colorString)
        
        if let headshotURLString = try studentValues.decodeIfPresent(String.self, forKey: .headshotURL) {
            headshotURL = URL(string: headshotURLString)
        }
        
        if let videoURLString = try studentValues.decodeIfPresent(String.self, forKey: .auditionVideoURL) {
            auditionVideoURL = URL(string: videoURLString)
        }
    }
}

extension Student: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StudentCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(person, forKey: .person)
        try container.encode(school, forKey: .school)
        try container.encode(teacher, forKey: .teacher)
        try container.encode(currentGrade, forKey: .currentGrade)
        try container.encode(expectedGraduation, forKey: .expectedGraduation)
        try container.encode(notes, forKey: .notes)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        try container.encode(dateFormatter.string(for: birthdate) ?? "", forKey: .birthdate)
                
        try container.encode(profileColor.hexValue(withHash: false), forKey: .profileColor)
        
        try container.encode(headshotURL?.absoluteString, forKey: .headshotURL)
        try container.encode(auditionVideoURL?.absoluteString, forKey: .auditionVideoURL)
    }
}
