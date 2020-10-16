//
//  ConflictEditView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/14/20.
//

import SwiftUI

// NEXT: Clean up this file.

struct ConflictEditView: View {
    @EnvironmentObject var portal: Portal
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var element: ConflictTabElement
    
    @State var showTypePicker: Bool = false
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Editing Conflict For")
                            .font(.body).italic()

                        Text(element.rehearsal.start.toStringWithFormat("EEEE, MMMM d, y"))
                            .font(.title2).bold()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.lightGray)
                .padding(.horizontal, -20)
                
                Text("Choose Students")
                    .portalLabelStyle()
                VStack {
                    ForEach(portal.family.compactMap({ $0 as? Student}), id:\.id) { student in
                        HStack {
                            Checkbox(isChecked: element.students.contains(student),
                                     activeColor: Color.myGreen,
                                     inactiveColor: Color.darkGray
                                )
                                .padding(.bottom, 8)
                            
                            StudentTab(name: student.person.firstName,
                                       color: student.profileColor,
                                       conflict: element.students.contains(student)
                                        ? element.type
                                        : nil )
                                .padding(.bottom, 8)
                                .opacity(element.students.contains(student)
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
                                         valueToDisplay: element.type.description)
                    .disabled(true)
                    .onTapGesture {
                        withAnimation {
                            showTypePicker.toggle()
                        }
                    }
                
                Spacer()
            }
            .disabled(showTypePicker ? true : false)
            .padding(16)
            .blur(radius: showTypePicker ? 5 : 0)
                        
            if showTypePicker {
                PortalConflictTypePicker(type: $element.type,
                                         presentationMode: $showTypePicker)
                    .transition(.move(edge: .bottom))
            }

        }
        .navigationTitle("Edit Conflict")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            portal.updateConflicts(withDetails: element)
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Save")
            }
            .font(.body)
            .foregroundColor(.myGreen)
        }), trailing: Button(action: {
            portal.removeConflictsWithIds(element.ids)
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Text("Delete")
                Image(systemName: "trash.fill")
            }
            .font(.body)
            .foregroundColor(Color.red)
        }))
    }
    
    func toggleElementForStudent(_ student: Student) {
        if element.students.contains(student) {
            element.students = element.students.filter({ s in
                s != student
            })
        } else {
            element.students.append(student)
        }
    }
}

struct ConflictEditView_Previews: PreviewProvider {
    @State static var selection: RehearsalViewTag? = .EditItem
    
    @State static var element =
        ConflictTabElement(ids: [1],
                           rehearsal: Production.default.rehearsals[0],
                           type: .Conflict,
                           students: [Student.default]
        )
    
    static var previews: some View {
        ConflictEditView(element: element)
            .environmentObject(Portal())
    }
}
