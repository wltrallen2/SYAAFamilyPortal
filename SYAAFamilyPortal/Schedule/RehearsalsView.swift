//
//  RehearsalsView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

struct RehearsalsView: View {
    @EnvironmentObject var portal: Portal
    
    // NEXT: Conflict list with insert, edit, & delete options
    // NEXT: Filter schedule by my children only (and dates?)
    // NEXT: Add graphics back to Login screens
    // NEXT: Connect to database
    
    // NEXT: Family disappears at bottom of home parent when home parent is edited. Might have to do with local data storage.
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (spacing: 0) {
                    ForEach(self.getAllRehearsals(), id:\.id) { rehearsal in
                        NavigationLink(destination:
                                        RehearsalDetailView(
                                            rehearsal: rehearsal,
                                            students: portal.getStudentsForRehearsal(rehearsal))) {
                            RehearsalTab(rehearsal: rehearsal,
                                         students: portal.getStudentsForRehearsal(rehearsal))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .navigationTitle("Rehearsal Schedule")
        .navigationBarItems(trailing: RehearsalsViewBarItems())
    }
    
    func getAllRehearsals() -> [Rehearsal] {
        var rehearsals: [Rehearsal] = []
        
        for production in portal.productions {
            rehearsals.append(contentsOf: production.rehearsals)
        }
        
        return rehearsals
    }
}

struct RehearsalsViewBarItems : View {
    @EnvironmentObject var portal: Portal
        
    var body: some View {
        HStack {
            NavigationLink(
                destination: ConflictsList(conflicts: portal.getAllConflictsForFamily()),
                label: {
                    Text("Manage Conflicts")
                })
        }
    }
}

struct RehearsalsView_Previews: PreviewProvider {
    static var previews: some View {
        RehearsalsView()
            .environmentObject(Portal())
    }
}
