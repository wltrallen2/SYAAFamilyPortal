//
//  SelectFilterView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/15/20.
//

import SwiftUI

struct SelectFilterView: View {
    @EnvironmentObject var portal: Portal
    
    @Binding var showFilter: Bool
    @ObservedObject var rehearsalFilter: RehearsalFilter
        
    var maxWidth: CGFloat = 280

    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            VStack (alignment: .leading){
                HStack {
                    Text("Filter Rehearsals")
                        .font(.title).fontWeight(.medium)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            showFilter.toggle()
                        }
                }
                .padding()
                .padding(.top, 16)

            }
            .frame(maxWidth: maxWidth)
            .background(Color.lightGray)
            
            ScrollView {
                VStack (alignment: .leading, spacing: 16){
                    FilterByStudentView(
                        selectedStudents: $rehearsalFilter.selectedStudents,
                        showAllOtherStudents: $rehearsalFilter.showAllOtherStudents)
                    
                    Divider()
                    
                    FilterByDateView(rehearsalFilter: rehearsalFilter,
                                     showAll: rehearsalFilter.showAll)
                    
                    Divider()
                    
                    FilterByConflictsView(
                        withConflicts: $rehearsalFilter.withConflicts,
                        showConflicts:
                            rehearsalFilter.withConflicts == .With
                            || rehearsalFilter.withConflicts == .All,
                        showNoConflicts:
                            rehearsalFilter.withConflicts == .Without
                            || rehearsalFilter.withConflicts == .All)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(maxWidth: maxWidth)
            }

            
            Spacer()
            
            HStack {
                Spacer()
                Text("Clear Filter")
                Image(systemName: "xmark.circle")
            }
            .foregroundColor(.red)
            .padding(16)
            .frame(maxWidth: maxWidth)
            .onTapGesture {
                rehearsalFilter.clearFilter()
                showFilter = false
            }
            
        }
        .background(Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color.gray, radius: 10.0)
                    )
    }
}

//**********************************************************************
// MARK: - Filter by Student View
//**********************************************************************
struct FilterByStudentView : View {
    @EnvironmentObject var portal: Portal
    
    @Binding var selectedStudents: [Student]
    @Binding var showAllOtherStudents: Bool

    var body: some View {
        VStack (alignment: .leading) {
            Text("Filter by Students")
                .portalLabelStyle()
            
            ForEach(portal.getMyStudents(), id:\.id) { student in
                HStack {
                    Checkbox(isChecked: selectedStudents.contains(student),
                             height: 30,
                             activeColor: .myGreen,
                             inactiveColor: .darkGray,
                             action: {})
                    StudentTab(name: student.person.firstName,
                               color: student.profileColor)
                }
                .padding(.leading, 16)
                .opacity(selectedStudents.contains(student) ? 1 : 0.6)
                .onTapGesture {
                    toggleStudent(student)
                }
            }
            
            HStack {
                Checkbox(isChecked: showAllOtherStudents,
                         height: 30,
                         activeColor: .myGreen,
                         inactiveColor: .darkGray,
                         action: {})
                StudentTab(name: "All Other Students",
                           color: Color(hex: "676767"))
            }
            .padding(.leading, 16)
            .opacity(showAllOtherStudents ? 1 : 0.6)
            .onTapGesture {
                showAllOtherStudents.toggle()
            }

        }
    }
        
    func toggleStudent(_ student: Student) {
        if selectedStudents.contains(student) {
            selectedStudents.removeAll(where: { s in
                        s.person.id == student.person.id })
        } else {
            selectedStudents.append(student)
        }
    }
}

//**********************************************************************
// MARK: - Filter by Date View
//**********************************************************************
struct FilterByDateView: View {
    @ObservedObject var rehearsalFilter: RehearsalFilter
    @State var showAll: Bool
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Filter by Dates View")
                .portalLabelStyle()
            
            HStack {
                Toggle("Show All", isOn: $showAll)
                    .labelsHidden()
                    .onChange(
                        of: showAll,
                        perform: { _ in
                            if showAll {
                                rehearsalFilter.resetDateRange()
                            }
                        }
                    )
                
                Text("Show All Dates")
            }.padding(.leading, 16)
            
            if !showAll {
                VStack (alignment: .leading, spacing: 16) {
                    HStack {
                        Text("From: ")
                            .frame(width: 50, alignment: .leading)
                        DatePicker(selection: $rehearsalFilter.startDate,
                                   displayedComponents: .date,
                                   label: {
                                    Text("From")
                                   }
                        )
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, -4)
                        .portalFieldStyle()
                    }
                    
                    HStack {
                        Text("To: ")
                            .frame(width: 50, alignment: .leading)
                        DatePicker(selection: $rehearsalFilter.endDate,
                                   displayedComponents: .date,
                                   label: {
                                    Text("From")
                                   }
                        )
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, -4)
                        .portalFieldStyle()

                    }
                }.padding(.leading, 16)

            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

//**********************************************************************
// MARK: - Filter by Conflicts View
//**********************************************************************
struct FilterByConflictsView: View {
    @Binding var withConflicts: ShowConflicts
    
    @State var showConflicts: Bool
    @State var showNoConflicts: Bool
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Filter by Conflicts View")
                .portalLabelStyle()
                        
            HStack {
                Toggle("No Conflicts", isOn: $showNoConflicts)
                    .labelsHidden()
                    .onChange(
                        of: showNoConflicts,
                        perform: { _ in
                            if showNoConflicts {
                                withConflicts = showConflicts
                                    ? .All : .Without
                            } else {
                                withConflicts = showConflicts
                                    ? .With : .None
                            }
                        }
                    )
                
                VStack {
                    Text("Show Rehearsal\nfor which I have\n")
                        + Text("NO conflicts")
                        .fontWeight(.heavy)
                        .foregroundColor(.myGreen)
                }.frame(height: 75)
                .padding(.leading, 8)

            }.padding(.leading, 16)
            
            HStack {
                Toggle("Conflicts", isOn: $showConflicts)
                    .labelsHidden()
                    .onChange(
                        of: showConflicts,
                        perform: { _ in
                            if showConflicts {
                                withConflicts = showNoConflicts
                                    ? .All : .With
                            } else {
                                withConflicts = showNoConflicts
                                    ? .Without : .None
                            }
                        }
                    )
                
                VStack {
                    Text("Show Rehearsal\nfor which\nI have ")
                        + Text("Conflicts")
                        .fontWeight(.heavy)
                        .foregroundColor(.red)
                }.frame(height: 75)
                .padding(.leading, 8)

                
            }.padding(.leading, 16)


        }
    }
}

struct SelectFilterView_Previews: PreviewProvider {
    @State static private var showFilter: Bool = false
    @State static private var selectedStudents: [Student] = []
    @State static private var withConflictsOnly: Bool = false
    @State static private var dateRange: Range<Date>?

    static var previews: some View {
        SelectFilterView(showFilter: $showFilter,
                         rehearsalFilter:
                            RehearsalFilter(portal: Portal()))
            .environmentObject(Portal())
            .previewLayout(.sizeThatFits)
    }
}
