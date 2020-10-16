//
//  RehearsalsView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

enum RehearsalViewTag: Int {
    case NilValue
    case RehearsalDetail
    case ManageConflicts
    case EditItem
    case AddItem
}

struct RehearsalsView: View {
    @EnvironmentObject var portal: Portal
    @State private var selection: RehearsalViewTag? = .NilValue
        
    @Binding var showFilter: Bool
    @ObservedObject var rehearsalFilter: RehearsalFilter

    
    // NEXT: Write filter code in this view
    // NEXT: Complete filter view, passing filter info back to this view
    // NEXT: Add graphics back to Login screens
    // NEXT: Connect to database
    
    // NEXT: Family disappears at bottom of home parent when home parent is edited. Might have to do with local data storage.
    
    var body: some View {
        ZStack (alignment: .topTrailing){
            ScrollView {
                VStack (spacing: 0) {
                    ForEach(rehearsalFilter.filteredRehearsals, id:\.id) { rehearsal in
                        VStack {
                            NavigationLink(
                                destination:
                                    RehearsalDetailView(
                                        selection: $selection,
                                        rehearsal: rehearsal,
                                        students: getMyStudents(rehearsal)),
                                tag: RehearsalViewTag.RehearsalDetail,
                                selection: $selection) {
                                EmptyView()
                            }
                            
                            RehearsalTab(rehearsal: rehearsal,
                                         students: portal.getMyStudentsForRehearsal(rehearsal))
                                .onTapGesture {
                                    self.selection = .RehearsalDetail
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle("Rehearsal Schedule")
        .navigationBarItems(trailing: RehearsalsViewBarItems(
                                selection: $selection,
                                showFilter: $showFilter))
    }
    
    func getMyStudents(_ rehearsal: Rehearsal) -> [Student] {
        return portal.getMyStudentsForRehearsal(rehearsal)
    }

}

struct RehearsalsViewBarItems : View {
    @EnvironmentObject var portal: Portal
    @Binding var selection: RehearsalViewTag?
    @Binding var showFilter: Bool
        
    var body: some View {
        HStack {
            NavigationLink(destination:
                            ConflictsListView(
                                selection: $selection,
                                conflicts: $portal.familyConflicts),
                           tag: RehearsalViewTag.ManageConflicts,
                           selection: $selection) {
                EmptyView()
            }
            .isDetailLink(false)
        Menu {
            Button(action: {
                self.selection = .ManageConflicts
            }, label: {
                Label("Manage Conflicts", systemImage: "calendar")
            })
            
            Button(action: {
                self.showFilter.toggle()
            }, label: {
                Label("Filter By...", systemImage: "line.horizontal.3.decrease.circle")
            })
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
}

struct RehearsalsView_Previews: PreviewProvider {
    @State static var rehearsals: [Rehearsal] = Production.default.rehearsals
    @State static var showFilter: Bool = false
    
    static var previews: some View {
        NavigationView {
            RehearsalsView(showFilter: $showFilter,
                           rehearsalFilter: RehearsalFilter(portal: Portal())
            )
                .environmentObject(Portal())
        }
    }
}
