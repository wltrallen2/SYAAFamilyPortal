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
        VStack {
            Text("\(student.person.firstName)'s Profile Edit View")
            
            Text("Birthdate: \(student.birthdate.slashStyle())")
            
            Text("Grad: \(student.expectedGraduation)")
            
            ColorPicker("Profile Color",
                        selection: $student.profileColor,
                        supportsOpacity: false)
        }
        .navigationTitle("\(student.person.firstName)'s Profile")
    }
}

struct StudentProfileEditView_Previews: PreviewProvider {
    @State static var student: Student = Student.default
    
    static var previews: some View {
        StudentProfileEditView(student: $student)
    }
}
