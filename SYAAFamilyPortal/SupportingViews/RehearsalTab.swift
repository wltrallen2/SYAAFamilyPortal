//
//  RehearsalTab.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import SwiftUI

struct RehearsalTab: View {
    @EnvironmentObject var portal: Portal
    
    var rehearsal: Rehearsal
    var students: [Student]
    
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 0) {
                VStack (alignment: .leading) {
                    Text(portal.getProductionTitleForRehearsal(rehearsal) ?? "Title")
                        .font(.caption).bold()
                    
                    HStack {
                        if(students.count > 0) {
                            ForEach(students, id:\.id) { student in
                                StudentTab(
                                    name: student.person.firstName,
                                    color: student.profileColor,
                                    conflict: portal.getConflictForStudent(student, atRehearsal: rehearsal))
                                    .frame(width: 120)
                                    .scaleEffect(0.75)
                            }
                        }
                    }
                    .padding(.vertical, students.count > 0
                                ? -4 : 0)
                    
                    Text(portal.getRehearsalDateStringForRehearsal(rehearsal))
                        .font(.headline).bold()
                    Text(portal.getRehearsalTimeStringForRehearsal(rehearsal))
                        .font(.subheadline).fontWeight(.medium)
                    Text(rehearsal.description)
                        .font(.callout).fontWeight(.light)
                }
                .padding(8)
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.blue)
            }
            .padding(.horizontal, 16)
            .background(getBackgroundColor())
            
            Divider()
        }
    }
                
    func getBackgroundColor() -> Color {
        return rehearsal.start.toStringWithFormat("yyyy-MM-dd") == Date().toStringWithFormat("yyyy-MM-dd")
            ? Color.yellow.opacity(0.3)
            : Color.white
    }
}

struct RehearsalTab_Previews: PreviewProvider {
    static var previews: some View {
        RehearsalTab(rehearsal: Production.default.rehearsals[0],
                     students: [Production.default.cast[0].student, Production.default.cast[2].student])
            .environmentObject(Portal())
            .previewLayout(.sizeThatFits)
    }
}
