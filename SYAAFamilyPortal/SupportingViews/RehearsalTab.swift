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
    var students: [Student] = [Student.default, Student.default]
    
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 0) {
                VStack (alignment: .leading) {
                    Text(getProductionTitle() ?? "Title")
                        .font(.caption).bold()
                    
                    HStack {
                        if(getStudentsForRehearsal().count > 0) {
                            ForEach(getStudentsForRehearsal(), id:\.id) { student in
                                StudentTab(name: student.person.firstName,
                                           color: student.profileColor)
                                    .frame(width: 120)
                                    .scaleEffect(0.75)
                            }
                        }
                    }
                    .padding(.vertical,
                             getStudentsForRehearsal().count > 0
                                ? -4 : 0)
                    
                    Text(getRehearsalDateString())
                        .font(.headline).bold()
                    Text(getRehearsalTimeString())
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
    
    func getProductionTitle() -> String? {
        return portal.getProductionForRehearsal(rehearsal)?.title
    }
    
    func getRehearsalDateString() -> String {
        return rehearsal.start.toStringWithFormat("EEEE, MMMM d, yyyy")
    }
    
    func getRehearsalTimeString() -> String {
        return rehearsal.start.toStringWithFormat("h:mm a")
        + "-"
            + rehearsal.end.toStringWithFormat("h:mm a")
    }
    
    func getStudentsForRehearsal() -> [Student] {
        var students: [Student] = []
        
        // Get a list of students, either a list of one student (me) for student user or a list of students in my family for adult user.
        let myStudents = portal.student != nil
            ? [ portal.student! ]
            : portal.getFamilyMembersOfType(Student.self)
        
        // Get the production and a list of all castings for that production
        guard let production = portal.getProductionForRehearsal(rehearsal) else { return [] }
        let casting = production.cast
        
        // For each student in the myStudents list, find all castings for that student, and for each casting, if the character is called to this rehearsal, add the student to the students array if they are not added already.
        for student in myStudents {
            let castings = casting.filter({ casting in
                return student.id == casting.student.id
            })
            
            for c in castings {
                if rehearsal.characterIds.contains(c.character.id)
                    && !students.contains(where: {s in
                        return s.id == student.id
                    }) {
                    students.append(student)
                }
            }
        }
        
        return students
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
                     students: [Student.default, Student.default])
            .environmentObject(Portal())
            .previewLayout(.sizeThatFits)
    }
}
