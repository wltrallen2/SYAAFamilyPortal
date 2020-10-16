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
            
            VStack (alignment: .leading, spacing: 16){
                FilterByStudentView(
                    selectedStudents: $rehearsalFilter.selectedStudents,
                    showAllOtherStudents: $rehearsalFilter.showAllOtherStudents)
                
                Divider()
                    .frame(maxWidth: maxWidth - 32)
                
                FilterByDateView(dateRange: $rehearsalFilter.dateRange)
                
                Divider()
                    .frame(maxWidth: maxWidth - 32)
                
                FilterByConflictsView(
                    withConflictsOnly: $rehearsalFilter.withConflictsOnly)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            
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
                // NEXT: Insert closure to clear filter here
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
    @Binding var dateRange: Range<Date>?
    @State var showAll: Bool = true
    
    var body: some View {
        VStack {
            Text("Filter by Dates View")
                .portalLabelStyle()
            
            Toggle(isOn: $showAll,
                   label: {
                Text("Show All")
            })
        }
    }
}

//**********************************************************************
// MARK: - Filter by Conflicts View
//**********************************************************************
struct FilterByConflictsView: View {
    @Binding var withConflictsOnly: Bool
    
    var body: some View {
        VStack {
            Text("Filter by Conflicts View")
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
