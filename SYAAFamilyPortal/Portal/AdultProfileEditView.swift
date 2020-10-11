//
//  ProfileView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI
import AQUI
import Combine

enum PhoneIndicator {
    case None
    case Phone1
    case Phone2
}

// MARK: -
struct AdultProfileEditView: View {
    @EnvironmentObject var portal: Portal
    @Binding var adult: Adult
    
    @State private var showStatePopover: Bool = false
    @State private var showPhonePopover: PhoneIndicator = .None
    
    var body: some View {
        ZStack (alignment: .bottom){
            VStack (spacing: 16) {
                ScrollView {
                    AdultProfileFields(adult: $adult,
                                       showStatePopover: $showStatePopover,
                                       showPhonePopover: $showPhonePopover)
                        .padding(16)
                    
                    
                    if(self.adult == self.portal.adult) {
                        Divider()
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        
                        FamilyProfileLinks()
                    }
                }
                .disabled(self.showStatePopover
                            || self.showPhonePopover != .None
                            ? true : false)
                .blur(radius: self.showStatePopover
                        || self.showPhonePopover != .None
                    ? 5 : 0)
            }
            .navigationTitle(Text("\(self.adult.person.firstName)'s Profile"))
            .background(Color("LightGray"))
        
            // MARK: Pickers
            if self.showStatePopover {
                StatesPicker(state: $adult.state,
                             presentationMode: $showStatePopover)
                    .transition(.move(edge: .bottom))
            }
            
            if self.showPhonePopover != .None {
                PhoneTypePicker(phoneType: (self.showPhonePopover == .Phone1)
                                    ? $adult.phone1Type
                                    : Binding($adult.phone2Type,
                                              replacingNilWith: PhoneType.NilValue),
                                presentationMode: $showPhonePopover)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

// MARK: -
struct AdultProfileFields: View {
    @Binding var adult: Adult
    
    @Binding var showStatePopover: Bool
    @Binding var showPhonePopover: PhoneIndicator
    
    var body: some View {
        VStack {
            
            // MARK: NAME FIELDS
            HStack (spacing: 16){
                ProfileTextField(
                    labelText: "First Name",
                    placeholder: "First Name",
                    fieldToDisplay: $adult.person.firstName)
                
                ProfileTextField(
                    labelText: "Last Name",
                    placeholder: "Last Name",
                    fieldToDisplay: $adult.person.lastName)
            }
            
            // MARK: ADDRESS FIELDS
            VStack (spacing: 4) {
                ProfileTextField(
                    labelText: "Address",
                    placeholder: "Address, Line 1",
                    fieldToDisplay: $adult.address1)

                ProfileTextField(
                    hasLabel: false,
                    placeholder: "Address, Line 2 (optional)",
                    fieldToDisplay: Binding($adult.address2, replacingNilWith: ""))
            }

            HStack (spacing: 16) {
                ProfileTextField(
                    labelText: "City",
                    placeholder: "City",
                    fieldToDisplay: $adult.city)

                ProfileTextField(
                    labelText: "State",
                    placeholder: "State",
                    fieldToDisplay: $adult.state)
                    .frame(width: 60)
                    .disabled(true)
                    .onTapGesture {
                        withAnimation {
                            self.showStatePopover.toggle()
                        }
                    }

                ProfileTextField(
                    labelText: "Zip",
                    placeholder: "Zip",
                    fieldToDisplay: $adult.zip)
                    .frame(width: 90)
                    .keyboardType(.numberPad)
            }

            // MARK: PHONE FIELDS
            HStack (spacing: 16) {
                // TODO: Fix phone number formatting
                ProfileTextField(
                    labelText: "Primary Phone",
                    placeholder: "Primary Phone",
                    fieldToDisplay: $adult.phone1)

                ProfilePickerPlaceholder(
                    placeholder: "Type",
                    valueToDisplay: self.adult.phone1Type.description)
                    .frame(width: 130)
                    .onTapGesture {
                        withAnimation {
                            self.showPhonePopover = .Phone1
                        }
                    }
            }

            HStack (spacing: 16) {
                // TODO: Fix phone number formatting
                ProfileTextField(
                    labelText: "Alternate Phone",
                    placeholder: "Alternate Phone",
                    fieldToDisplay: Binding($adult.phone2, replacingNilWith: ""))

                ProfilePickerPlaceholder(
                    placeholder: "Type",
                    valueToDisplay: self.adult.phone2Type?.description ?? "")
                    .frame(width: 130)
                    .onTapGesture {
                        withAnimation {
                            self.showPhonePopover = .Phone2
                        }
                    }
            }

            // MARK: EMAIL FIELDS
            ProfileTextField(
                labelText: "Email",
                placeholder: "Email",
                fieldToDisplay: $adult.email
            )
            .autocapitalization(.none)

        }
    }
}

// MARK: -
struct FamilyProfileLinks: View {
    @EnvironmentObject var portal: Portal
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Group {
                Text("Family Members")
                    .bold()
                    .font(.title)
                    .padding(.bottom, 4)
            
                HStack {
                    Text("Tap to Edit")
                        .italic()
                    
                    VStack {
                        Divider()
                    }
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView (.horizontal) {
                HStack(spacing: 16) {
                    ForEach(self.portal.getFamilyMembersOfType(Student.self), id:\.id) { student in
                        NavigationLink(destination: ProfileWrapperView(
                                        adult: nil,
                                        student: student)) {
                            StudentTab(name: student.person.firstName,
                                       color: student.profileColor)
                        }
                    }
                }
                .padding()
            }
            .ignoresSafeArea()
            
            HStack {
                Text("Other Adults")
                    .italic()
                    .font(.title2)
                
                VStack {
                    Divider()
                }
            }
            .padding(.horizontal, 16)
        }
        
        ForEach(self.portal.getFamilyMembersOfType(Adult.self), id:\.id) { adult in
            NavigationLink(destination:
                            ProfileWrapperView(
                                adult: adult,
                                student: nil)) {
                AdultTab(name: "\(adult.person.firstName) \(adult.person.lastName)")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: -
struct AdultProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        AdultProfileEditView(adult: .constant(.default))
            .environmentObject(Portal())
            .previewLayout(.fixed(width: 400, height: 1000))
    }
}
