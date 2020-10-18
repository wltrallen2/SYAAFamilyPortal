//
//  UpdateStudentData.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/18/20.
//

import Foundation

struct UpdateStudentData {
    var student: Student
    var userId: Int
    
    init(student: Student, user: User) {
        self.student = student
        self.userId = user.id
    }
}

enum UpdateStudentCodingKeys: CodingKey {
    case userId
    case personId
    case firstName
    case lastName
    case hasVerified
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

extension UpdateStudentData: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UpdateStudentCodingKeys.self)
        
        try container.encode(userId, forKey: .userId)
        try container.encode(student.person.id, forKey: .personId)
        try container.encode(student.person.firstName, forKey: .firstName)
        try container.encode(student.person.lastName, forKey: .lastName)
        try container.encode(student.person.hasVerified, forKey: .hasVerified)
        
        try container.encode(student.school, forKey: .school)
        try container.encode(student.teacher, forKey: .teacher)
        try container.encode(student.currentGrade, forKey: .currentGrade)
        try container.encode(student.expectedGraduation, forKey: .expectedGraduation)
        try container.encode(student.notes, forKey: .notes)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        try container.encode(dateFormatter.string(for: student.birthdate) ?? "", forKey: .birthdate)
                
        try container.encode(student.profileColor.hexValue(withHash: false), forKey: .profileColor)
        
        try container.encode(student.headshotURL?.absoluteString, forKey: .headshotURL)
        try container.encode(student.auditionVideoURL?.absoluteString, forKey: .auditionVideoURL)
    }
}

