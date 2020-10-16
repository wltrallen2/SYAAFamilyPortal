//
//  ConflictAddView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/14/20.
//

import SwiftUI

// NEXT: Clean up this file.

struct ConflictAddView: View {
    @EnvironmentObject var portal: Portal
    @Binding var selected: RehearsalViewTag?
            
    
    var body: some View {
        ConflictAddFields(selected: $selected,
                          rehearsal: portal.productions
                            .compactMap({ $0.rehearsals })
                            .flatMap({ $0 })
                            .sorted(by: { (a, b) in a.start < b.start }).first!,
                          selectedStudents: [],
                          type: ConflictType.Conflict,
                          rehearsals: portal.productions
                            .compactMap({ $0.rehearsals })
                            .flatMap({ $0 })
                            .sorted(by: { (a, b) in a.start < b.start }),
                          students: portal.student != nil
                            ? [ portal.student! ]
                            : portal.family.compactMap({ $0 as? Student }))
    }
    
}

struct ConflictAddFields: View {
    @EnvironmentObject var portal: Portal
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selected: RehearsalViewTag?
    
    @State var rehearsal: Rehearsal
    @State var selectedStudents: [Student]
    @State var type: ConflictType = .Conflict
        
    @State var showRehearsalPicker: Bool = false
    @State var showTypePicker: Bool = false
    
    var rehearsals: [Rehearsal]
    var students: [Student]
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack (alignment: .leading) {
                ProfilePickerPlaceholder(
                    labelText: "Choose Rehearsal",
                    placeholder: "Rehearsal",
                    valueToDisplay: rehearsal.start.toStringWithFormat("EEEE, MMMM d, y"))
                    .disabled(true)
                    .onTapGesture() {
                        self.showRehearsalPicker.toggle()
                    }
                                
                Text("Choose Students")
                    .portalLabelStyle()
                VStack {
                    ForEach(students, id:\.id) { student in
                        HStack {
                            Checkbox(isChecked: selectedStudents.contains(student),
                                     activeColor: Color.myGreen,
                                     inactiveColor: Color.darkGray
                                )
                                .padding(.bottom, 8)
                            
                            StudentTab(name: student.person.firstName,
                                       color: student.profileColor,
                                       conflict: selectedStudents.contains(student)
                                        ? type : nil )
                                .padding(.bottom, 8)
                                .opacity(selectedStudents.contains(student)
                                            ? 1.0 : 0.7)
                            
                            Spacer()
                        }
                        .padding(.leading, 24)
                        .onTapGesture {
                            toggleElementForStudent(student)
                        }
                    }
                }
                                
                ProfilePickerPlaceholder(labelText: "Conflict Description",
                                         placeholder: "Choose Conflict Details",
                                         valueToDisplay: type.description)
                    .disabled(true)
                    .onTapGesture {
                        withAnimation {
                            showTypePicker.toggle()
                        }
                    }
                
                Spacer()
            }
            .disabled(showRehearsalPicker || showTypePicker
                        ? true : false)
            .padding(16)
            .blur(radius: showRehearsalPicker || showTypePicker
                ? 5 : 0)
            
            if showRehearsalPicker {
                PortalRehearsalPicker(rehearsal: $rehearsal,
                                      presentationMode: $showRehearsalPicker,
                                      rehearsals: rehearsals)
                    .transition(.move(edge: .bottom))
            }
            
            if showTypePicker {
                PortalConflictTypePicker(type: $type,
                                         presentationMode: $showTypePicker)
                    .transition(.move(edge: .bottom))
            }

        }
        .navigationTitle("Add New Conflict")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            var ids = [Int]()
            for student in selectedStudents {
                ids.append(Int("\(rehearsal.id)\(student.person.id)")!)
            }
            
            let elements = ConflictTabElement(ids: ids,
                                              rehearsal: rehearsal,
                                              type: type,
                                              students: selectedStudents)
            
            portal.addConflicts(withDetails: elements)
            // For future reference, https://stackoverflow.com/questions/59848678/swiftui-custom-navigation-back-button-oddly-jumping-back-and-forth-between was needed for the menu on the root view of the RehearsalView; however, for views that are NOT detail views, I had to use the solution found at https://stackoverflow.com/questions/57334455/swiftui-how-to-pop-to-root-view to make sure that these buttons did not pop the user back to the root view.
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Save")
            }
            .font(.body)
        }), trailing: Button(action: {
            self.presentationMode.wrappedValue.dismiss()

        }, label: {
            HStack {
                Text("Cancel")
                Image(systemName: "xmark")
            }
            .font(.body)
            .foregroundColor(Color.red)
        }))
    }
    
    func toggleElementForStudent(_ student: Student) {
        var selected = [Student]()
        selected.append(contentsOf: selectedStudents)
        
        if selected.contains(student) {
            selected.removeAll(where: { s in
                s.person.id == student.person.id
            })
        } else {
            selected.append(student)
        }
        
        selectedStudents = selected
    }
}

struct ConflictAddView_Previews: PreviewProvider {
    @State static var selected: RehearsalViewTag? = .AddItem
    
    static var previews: some View {
        NavigationView {
            ConflictAddView(selected: $selected)
                .environmentObject(Portal())
        }
    }
}
