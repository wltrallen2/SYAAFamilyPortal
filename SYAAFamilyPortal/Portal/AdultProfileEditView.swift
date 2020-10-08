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
                    
                    // TODO: FamilyProfileLinks()
                }
                .disabled(self.showStatePopover
                            || self.showPhonePopover != .None
                            ? true : false)
                .padding(16)
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

                PickerPlaceholder(
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

                PickerPlaceholder(
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
struct AdultProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        AdultProfileEditView(adult: .constant(.default))
    }
}
