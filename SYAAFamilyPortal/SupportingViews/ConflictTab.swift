//
//  ConflictTab.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/13/20.
//

import SwiftUI

struct ConflictTab: View, Hashable {
    var students: [Student]
    var date: Date
    var conflictType: ConflictType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(conflictType)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading, spacing: 0){
                    VStack (alignment: .leading, spacing: 0) {
                    Text(date.toStringWithFormat("EEEE, MMMM d, y"))
                        .fontWeight(.medium)
                    
                    Text(conflictType.description)
                        .font(.caption)
                        .italic()
                    }
                    .padding(.leading, 4)
                    .padding(.bottom, 4)

                    HStack (spacing: 16){
                        ForEach(students, id:\.id) { student in
                            StudentTab(name: student.person.firstName,
                                       color: student.profileColor,
                                       conflict: conflictType)
                        }
                        
                        Spacer()
                    }
                
                }
                
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
            }
            .padding(.top, 8)
            .padding(.horizontal, 14)
            
            Divider()
        }
    }
}

struct ConflictTab_Previews: PreviewProvider {
    static var student1 = Portal().getStudentWithId(Production.default.castingLinks[0].studentId)!
    static var student2 =
        Portal().getStudentWithId(Production.default.castingLinks[2].studentId)!
    
    static var previews: some View {
        Group {
            ConflictTab(students: [student1, student2], date: Date(), conflictType: .Conflict)
            .previewLayout(.sizeThatFits)
        
        ConflictTab(students: [student1, student2], date: Date(), conflictType: .LeaveEarly)
            .previewLayout(.sizeThatFits)

        ConflictTab(students: [student1, student2], date: Date(), conflictType: .ArriveLate)
                .previewLayout(.sizeThatFits)

        }

    }
}
