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
                                rehearsalFilter: rehearsalFilter,
                                selection: $selection,
                                showFilter: $showFilter))
    }
    
    func getMyStudents(_ rehearsal: Rehearsal) -> [Student] {
        return portal.getMyStudentsForRehearsal(rehearsal)
    }

}

struct RehearsalsViewBarItems : View {
    @EnvironmentObject var portal: Portal
    @ObservedObject var rehearsalFilter: RehearsalFilter
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
                
                Button(action: {
                    let printController = UIPrintInteractionController.shared
                    let printInfo = UIPrintInfo(dictionary: nil)
                    printInfo.outputType = .general
                    printInfo.jobName = "Print Job"
                    printController.printInfo = printInfo
                    
                    let htmlRehearsalPrint = RehearsalPrint(
                        forStudents: rehearsalFilter.selectedStudents,
                        andRehearsals: rehearsalFilter.filteredRehearsals,
                        usingPortal: portal)
                    
                    let formatter = UIMarkupTextPrintFormatter(markupText: htmlRehearsalPrint.html)
                    formatter.perPageContentInsets = UIEdgeInsets(top: 36, left: 36, bottom: 36, right: 36)
                    printController.printFormatter = formatter
                    
                    printController.present(animated: true, completionHandler: nil)
                }, label: {
                    Label("Print Schedule", systemImage: "printer")
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
