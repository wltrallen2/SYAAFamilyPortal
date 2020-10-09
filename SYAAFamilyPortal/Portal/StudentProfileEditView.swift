//
//  StudentProfileEditView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import SwiftUI

struct StudentProfileEditView: View {
    @Binding var student: Student
    
    var body: some View {
        ZStack (alignment: .bottom){
            VStack (spacing: 16) {
                ScrollView {
                    StudentProfileFields(student: $student)
                }
//                .disabled(self.showStatePopover
//                            || self.showPhonePopover != .None
//                            ? true : false)
                .padding(16)
//                .blur(radius: self.showStatePopover
//                        || self.showPhonePopover != .None
//                    ? 5 : 0)
            }
            .navigationTitle(Text("\(self.student.person.firstName)'s Profile"))
            .background(Rectangle()
                            .fill(self.student.profileColor)
                            .opacity(0.3)
            )
        
            // MARK: Pickers
//            if self.showStatePopover {
//                StatesPicker(state: $adult.state,
//                             presentationMode: $showStatePopover)
//                    .transition(.move(edge: .bottom))
        }
    }
}

struct StudentProfileFields: View {
    @Binding var student: Student
    
    var body: some View {
        VStack {
            Text("\(student.person.firstName)'s Profile Edit View")
            
            Text("Birthdate: \(student.birthdate.slashStyle())")
            
            Text("Grad: \(student.expectedGraduation)")
            
            ColorPicker("Profile Color",
                        selection: $student.profileColor,
                        supportsOpacity: false)
        }
    }
}

struct StudentProfileEditView_Previews: PreviewProvider {
    @State static var student: Student = Student.default
    
    static var previews: some View {
        StudentProfileEditView(student: $student)
    }
}
