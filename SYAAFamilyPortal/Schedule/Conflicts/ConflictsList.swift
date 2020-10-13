//
//  ConflictsList.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/13/20.
//

import SwiftUI

struct ConflictTabElement: Hashable, Equatable {
    var date: Date
    var type: ConflictType
    var students: [Student]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(type)
    }
}

struct ConflictsList: View {
    @EnvironmentObject var portal: Portal

    var conflicts: [Conflict]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(getConflictTabs(), id:\.self) { conflictTab in
                    conflictTab
                }
            }
        }
        .navigationTitle("Conflicts List")

    }
    
    func getConflictTabs() -> [ConflictTab] {
        var tabs = [ConflictTab]()
        
        for element in getConflictTabElements() {
            tabs.append(ConflictTab(
                            students: element.students,
                            date: element.date,
                            conflictType: element.type))
        }
        
        return tabs
    }
    
    func getConflictTabElements() -> [ConflictTabElement] {
        var elements = [ConflictTabElement]()
        
        for conflict in conflicts {
            let rehearsal = portal.getRehearsalWithId(conflict.rehearsalId)
            let date = rehearsal?.start
            
            var students = [Student]()
            if elements.contains(where: { element in
                return date == element.date
                    && conflict.type == element.type
            }) {
                let element = elements.first(where: {element in
                    element.date == date
                        && conflict.type == element.type
                })
                
                students.append(contentsOf: element?.students ?? [])
                elements.removeAll(where: { element in
                    element.date == date
                        && element.type == conflict.type
                })
            }
            
            students.append(portal.getStudentWithId(conflict.studentId, inProduction: portal.getProductionForRehearsal(rehearsal!)!)!)
            
            elements.append(
                ConflictTabElement(date: date!,
                                   type: conflict.type,
                                   students: students)
            )

        }
        
        return elements
    }
}

struct ConflictsList_Previews: PreviewProvider {
    static var previews: some View {
        ConflictsList(conflicts: Portal().getAllConflictsForFamily())
            .environmentObject(Portal())
    }
}
