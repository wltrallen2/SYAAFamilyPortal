//
//  StudentProfileEditView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import SwiftUI

enum StudentFieldPicker {
    case None
    case Birthdate
    case Graduation
    case Grade
    case Color
}

struct StudentProfileEditView: View {
    @Binding var student: Student
    @State var showPicker: StudentFieldPicker = .Color
    
    var body: some View {
        ZStack (alignment: .bottom){
            VStack (spacing: 16) {
                ScrollView {
                    StudentProfileFields(student: $student,
                                         showPicker: $showPicker)
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
            if self.showPicker == .Birthdate {
                BirthdatePickerView(date: $student.birthdate,
                                    presentationMode: $showPicker)
            }
            
            if self.showPicker == .Graduation {
                GraduationPickerView(gradYear: $student.expectedGraduation,
                                     presentationMode: $showPicker)
            }
            
            if self.showPicker == .Grade {
                GradeSliderView(grade: $student.currentGrade,
                                presentationMode: $showPicker)
            }
        }
    }
}

struct StudentProfileFields: View {
    @Binding var student: Student
    @Binding var showPicker: StudentFieldPicker
    @State var showUnimplementedAlert: Bool = false
    
    fileprivate var age: Int {
        get {
            return calculateAgeFromDate(self.student.birthdate)
        }
    }
        
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                ProfileTextField(
                    labelText: "First Name",
                    placeholder: "First Name",
                    fieldToDisplay: $student.person.firstName)
                
                ProfileTextField(
                    labelText: "Last Name",
                    placeholder: "Last Name",
                    fieldToDisplay: $student.person.lastName)
            }
            
            HStack(alignment: .bottom ,spacing: 16) {
                ProfilePickerPlaceholder(
                    labelText: "Birthdate",
                    placeholder: "Birthdate",
                    valueToDisplay: student.birthdate.slashStyle())
                    .onTapGesture {
                        self.showPicker = .Birthdate
                    }
                
                VStack (alignment: .leading) {
                    Text("Current Age")
                        .portalLabelStyle()
                    
                    Text("\(age)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .portalFieldStyle()
                }
                .frame(width: 85)
                
                VStack (alignment: .center){
                    Text("Profile Color")
                        .portalLabelStyle()
                        .frame(maxHeight: .infinity)
                    
                    HStack {
                        ColorPicker("",
                                    selection: $student.profileColor,
                                    supportsOpacity: false)
                        
                        Text(" ")
                    }
                    .portalFieldStyle(fillColor: student.profileColor)
                }
                .frame(width: 70)
            }
            
            HStack(alignment: .bottom ,spacing: 16) {
                ProfilePickerPlaceholder(
                    labelText: "Expected Graduation",
                    placeholder: "Exp. Grad.",
                    valueToDisplay: student.expectedGraduation)
                    .onTapGesture {
                        self.showPicker = .Graduation
                    }
                
                ProfilePickerPlaceholder(
                    labelText: "Current Grade",
                    placeholder: "Grade",
                    valueToDisplay: getGradeLabel())
                    .onTapGesture {
                        self.showPicker = .Grade
                    }
                .frame(width: 85)
            }
            
            ProfileTextField(
                labelText: "School",
                placeholder: "School",
                fieldToDisplay: Binding($student.school, replacingNilWith: ""))
                .onTapGesture {
                    self.showUnimplementedAlert.toggle()
                }
            
            ProfileTextField(
                labelText: "Teacher",
                placeholder: "Teacher",
                fieldToDisplay: Binding($student.teacher, replacingNilWith: ""))
                .onTapGesture {
                    self.showUnimplementedAlert.toggle()
                }
            
            VStack (alignment: .leading){
                Text("Notes")
                    .portalLabelStyle()
                
                TextEditor(text: $student.notes)
                    .frame(height: 200)
                    .portalFieldStyle()
            }

        }
        .alert(isPresented: $showUnimplementedAlert,
               content: {
                Alert(title: Text("Coming Soon!"),
                      message:
                        Text("This feature will be implemented in a future release"),
                      dismissButton: .default(Text("OK")))
               }
        )
    }
    
    private func calculateAgeFromDate(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year!
    }
    
    private func getGradeLabel() -> String {
        return self.student.currentGrade == 0
            ? "K" : "\(self.student.currentGrade)"
    }
}


struct StudentProfileEditView_Previews: PreviewProvider {
    @State static var student: Student = Student.default
    
    static var previews: some View {
        StudentProfileEditView(student: $student)
            .environmentObject(Portal())
    }
}
