//
//  ConflictsListView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/13/20.
//

import SwiftUI

struct ConflictTabElement: Hashable, Equatable {
    var ids: [Int]
    var date: Date
    var type: ConflictType
    var students: [Student]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(type)
    }
}

struct ConflictsListView: View {
    @EnvironmentObject var portal: Portal

    @State var conflicts: [Conflict]
    
    var body: some View {
        List {
            ForEach(getConflictTabs(), id:\.self) { conflictTab in
                    conflictTab
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Conflicts List")
    }
    
    func delete(at offsets: IndexSet) {
        let element = getConflictTabElements()[offsets.first!]
        for id in element.ids {
            
            // Remove from portal.familyConflicts and from database
            portal.removeConflict(conflicts.first(where: { conflict in
                                                    conflict.id == id})!)
            
            // Remove from current view
            conflicts.removeAll(where: { conflict in
                conflict.id == id
            })
        }
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
            var ids = [Int]()
            if elements.contains(where: { element in
                return date == element.date
                    && conflict.type == element.type
            }) {
                let element = elements.first(where: {element in
                    element.date == date
                        && conflict.type == element.type
                })
                
                ids.append(contentsOf: element?.ids ?? [])
                students.append(contentsOf: element?.students ?? [])
                elements.removeAll(where: { element in
                    element.date == date
                        && element.type == conflict.type
                })
            }
            
            ids.append(conflict.id)
            students.append(portal.getStudentWithId(conflict.studentId)!)
            
            elements.append(
                ConflictTabElement(ids: ids,
                                   date: date!,
                                   type: conflict.type,
                                   students: students)
            )

        }
        
        return elements
    }
}

struct ConflictsList_Previews: PreviewProvider {
    static var conflicts: [Conflict] = load("conflictData.json")
    
    static var previews: some View {
        ConflictsListView(conflicts: conflicts)
            .environmentObject(Portal())
    }
}
