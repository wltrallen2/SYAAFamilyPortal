//
//  ConflictsListView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/13/20.
//

import SwiftUI

struct ConflictTabElement: Hashable, Equatable {
    var ids: [Int]
    var rehearsal: Rehearsal
    var type: ConflictType
    var students: [Student]
            
    func hash(into hasher: inout Hasher) {
        hasher.combine(rehearsal.id)
        hasher.combine(ids)
        hasher.combine(type)
    }
}

// FIXME: Adding or editing a conflict resets the RehearsalFilter object. Debug in a future iteration.
struct ConflictsListView: View {
    @EnvironmentObject var portal: Portal

    @Binding var selection: RehearsalViewTag?
    @Binding var conflicts: [Conflict]
    
    var body: some View {
        List {
            ForEach(getConflictTabElements(), id:\.self) { element in
                ZStack {
                    NavigationLink(destination:
                                    ConflictEditView(
                                        element: element)) {
                        EmptyView()
                    }
                    
                    ConflictTab(students: element.students,
                                rehearsal: element.rehearsal,
                                conflictType: element.type)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Conflicts List")
        .navigationBarItems(trailing: AddConflictBarItem(selection: $selection))
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
    
    func getConflictTabElements() -> [ConflictTabElement] {
        var elements = [ConflictTabElement]()
        
        for conflict in conflicts {
            guard let rehearsal = portal.getRehearsalWithId(conflict.rehearsalId) else { break }
            
            var students = [Student]()
            var ids = [Int]()
            if elements.contains(where: { element in
                return rehearsal.id == element.rehearsal.id
                    && conflict.type == element.type
            }) {
                let element = elements.first(where: {element in
                    element.rehearsal.id == rehearsal.id
                        && conflict.type == element.type
                })
                
                ids.append(contentsOf: element?.ids ?? [])
                students.append(contentsOf: element?.students ?? [])
                elements.removeAll(where: { element in
                    element.rehearsal.id == rehearsal.id
                        && element.type == conflict.type
                })
            }
            
            ids.append(conflict.id)
            students.append(portal.getStudentWithId(conflict.studentId)!)
            
            elements.append(
                ConflictTabElement(ids: ids,
                                   rehearsal: rehearsal,
                                   type: conflict.type,
                                   students: students)
            )

        }
        
        return elements
    }
}

struct AddConflictBarItem: View {
    @Binding var selection: RehearsalViewTag?
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: ConflictAddView(selected: $selection),
                tag: RehearsalViewTag.AddItem,
                selection: $selection) {
                EmptyView()
            }
            .isDetailLink(false)
            Button(action: {
                self.selection = .AddItem
            },
                   label: {
                    Text("Add Conflict")
                    Image(systemName: "plus.circle")
                })
        }
    }
}

struct ConflictsList_Previews: PreviewProvider {
    @State static var selection: RehearsalViewTag? = .ManageConflicts
    @State static var conflicts: [Conflict] = load("conflictData.json")
    
    static var previews: some View {
        NavigationView {
            ConflictsListView(selection: $selection,
                              conflicts: $conflicts)
                .environmentObject(Portal())
        }
    }
}
