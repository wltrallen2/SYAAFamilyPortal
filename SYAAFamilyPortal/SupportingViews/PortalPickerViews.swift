//
//  PickerViews.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import SwiftUI

struct SaveButtonWithPresentationToggle: View {
    @Binding var presentationMode: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button("Save", action: {
                withAnimation {
                    self.presentationMode.toggle()
                }
            })
        }
    }
}

struct StatesPicker: View {
    @Binding var state: String
    @Binding var presentationMode: Bool
    
    var body: some View {
        VStack {
            SaveButtonWithPresentationToggle(presentationMode: $presentationMode)
            
            Picker(selection: $state, label: Text("State")) {
                ForEach(statesDict, id: \.key) { key, value in
                    Text(value)
                }
            }
        }
        .portalPickerStyle()
    }
}

struct PhoneTypePicker: View {
    @Binding var phoneType: PhoneType
    @Binding var presentationMode: PhoneIndicator
        
    private let types: [PhoneType] = [ .NilValue, .Cell, .Work, .Landline ]
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Save", action: {
                    withAnimation {
                        self.presentationMode = .None
                    }
                })
            }

            Picker(selection: $phoneType,
                   label: Text("Phone Type")) {
                ForEach(types, id: \.self) { type in
                    Text(type.description)
                }
            }
        }
        .portalPickerStyle()
    }
}

struct SaveButtonWithStudentFieldPicker: View {
    @Binding var presentationMode: StudentFieldPicker
    
    var body: some View {
        HStack {
            Spacer()
            Button("Save", action: {
                withAnimation {
                    self.presentationMode = .None
                }
            })
        }
    }
}

struct BirthdatePickerView: View {
    @Binding var date: Date
    @Binding var presentationMode: StudentFieldPicker
        
    var body: some View {
        VStack {
            SaveButtonWithStudentFieldPicker(presentationMode: $presentationMode)
            
            DatePicker(selection: $date,
                       displayedComponents: .date) {
                Text("Choose Birthdate")
            }
            .datePickerStyle(GraphicalDatePickerStyle())
        }
        .portalPickerStyle(height: 350)
    }
}

struct GraduationPickerView: View {
    @Binding var gradYear: String
    @Binding var presentationMode: StudentFieldPicker
    
    var body: some View {
        VStack {
            SaveButtonWithStudentFieldPicker(presentationMode: $presentationMode)
            
            Picker("Expected Graduation",
                   selection: $gradYear) {
                ForEach(getPickerYears(), id:\.self) { year in
                    Text(year)
                }
            }
        }
        .portalPickerStyle()
    }
    
    private func getPickerYears() -> [String] {
        var years: [String] = [""]
        
        let yearInt = Int(Date().year())
        for year in yearInt!...(yearInt!+20) {
            years.append("\(year)")
        }
        
        return years
    }
}

extension Int {
    var float: Float {
        get { Float(self) }
        set { self = Int(newValue) }
    }
}

struct GradeSliderView: View {
    @Binding var grade: Int
    @Binding var presentationMode: StudentFieldPicker
    
    
    var body: some View {
        VStack {
            SaveButtonWithStudentFieldPicker(presentationMode: $presentationMode)
            
            Slider(value: $grade.float,
                   in: 0...12.0,
                   step: 1.0)
            
            HStack {
                Text("K")
                Spacer()
                Text("12")
            }
            .padding(.horizontal, 4)
            
            HStack {
                Text("Grade Selected: ")
                    .portalLabelStyle()
                
                Text(grade == 0 ? "K" : "\(grade)")
                    .frame(width: 80)
                    .portalFieldStyle()
                    .padding(.bottom, 16)
            }
        }
        .portalPickerStyle(height: 145)
    }
}

struct PickerViews_Previews: PreviewProvider {
    @State static var adult: Adult = Adult.default
    @State static var student: Student = Student.default
    @State static var showBirthdate: StudentFieldPicker = .Birthdate
    @State static var showGraduation: StudentFieldPicker = .Graduation
    @State static var showGrade: StudentFieldPicker = .Grade

    static var previews: some View {
        Group {
            StatesPicker(state: $adult.state,
                         presentationMode: .constant(true))
                .previewLayout(.sizeThatFits)
            
            PhoneTypePicker(phoneType: $adult.phone1Type,
                            presentationMode: .constant(PhoneIndicator.Phone1))
                .previewLayout(.sizeThatFits)
            
            BirthdatePickerView(date: $student.birthdate,
                                presentationMode: $showBirthdate)
                .previewLayout(.sizeThatFits)
            
            GraduationPickerView(gradYear: $student.expectedGraduation,
                                 presentationMode: $showGraduation)
                .previewLayout(.sizeThatFits)
            
            GradeSliderView(grade: $student.currentGrade,
                            presentationMode: $showGrade)
                .previewLayout(.sizeThatFits)
        }
    }
}
