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
    var expectedGraduation: Date
    var notes: String
    var profileColor: UIColor
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
    
    static let `default` = Student(id: 2, person: Person(id: 2, firstName: "Jane", lastName: "Doe", hasVerified: true), birthdate: Date(timeIntervalSinceNow: TimeInterval(-60 * 60 * 24 * 365 * 6)), school: "May-Allen Academy", teacher: nil, currentGrade: 2, expectedGraduation: Date(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 365 * 12)), notes: "Such an awesome kiddo", profileColor: UIColor(red: 255/255, green: 182/255, blue: 203/255, alpha: 1.0), headshotURL: nil, auditionVideoURL: nil)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthdate = dateFormatter.date(from: birthdateString) ?? Date()
        
        let gradString = try studentValues.decode(String.self, forKey: .expectedGraduation)
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 5
        components.day = 31
        components.year = Int(gradString) ?? calendar.component(.year, from: Date())
        expectedGraduation = calendar.date(from: components) ?? Date()
        
        let colorString = try studentValues.decode(String.self, forKey: .profileColor)
        profileColor = UIColor(hex: "#" + colorString + "ff") ?? UIColor(Color.black)
        
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
        try container.encode(teacher, forKey: .school)
        try container.encode(currentGrade, forKey: .school)
        try container.encode(notes, forKey: .school)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        try container.encode(dateFormatter.string(for: birthdate) ?? "", forKey: .birthdate)
        
        dateFormatter.dateFormat = "yyyy"
        try container.encode(dateFormatter.string(for: expectedGraduation) ?? "", forKey: .expectedGraduation)
        
        try container.encode(profileColor.hexString(), forKey: .profileColor)
        
        try container.encode(headshotURL?.absoluteString, forKey: .headshotURL)
        try container.encode(auditionVideoURL?.absoluteString, forKey: .auditionVideoURL)
    }
}

// TODO: Extract extension and rewrite as needed.
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    public func hexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
     }

}
