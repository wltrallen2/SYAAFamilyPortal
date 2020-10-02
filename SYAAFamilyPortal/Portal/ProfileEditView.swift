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

struct ProfileEditView: View {
    @Binding var adult: Adult
    @State private var showStatePopover: Bool = false
    @State private var showPhonePopover: PhoneIndicator = .None
    
    var body: some View {
        ZStack (alignment: .bottom){
            VStack (spacing: 16) {
                ScrollView {
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
                    
                    HStack (spacing: 16) {
                        // TODO: Fix phone number formatting
                        ProfileTextField(
                            labelText: "Primary Phone",
                            placeholder: "Primary Phone",
                            fieldToDisplay: $adult.phone1)
                        
                        ProfileDropDownPlaceholder(
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
                        
                        ProfileDropDownPlaceholder(
                            placeholder: "Type",
                            valueToDisplay: self.adult.phone2Type?.description ?? "")
                            .frame(width: 130)
                            .onTapGesture {
                                withAnimation {
                                    self.showPhonePopover = .Phone2
                                }
                            }
                    }
                    
                    ProfileTextField(
                        labelText: "Email",
                        placeholder: "Email",
                        fieldToDisplay: $adult.email
                    )

                    
                    Spacer()
                }
                .disabled(self.showStatePopover
                            || self.showPhonePopover != .None
                            ? true : false)
                .padding(16)
                .blur(radius: self.showStatePopover
                        || self.showPhonePopover != .None
                    ? 5 : 0)
            }
            .background(Color("LightGray"))
        }
        
        if self.showStatePopover {
            StatesPicker(adult:$adult, presentationMode: $showStatePopover)
                .transition(.move(edge: .bottom))
        }
        
        if self.showPhonePopover != .None {
            PhoneTypePicker(adult: $adult,
                            presentationMode: $showPhonePopover)
                .transition(.move(edge: .bottom))
        }
    }
}

struct ProfileTextField: View {
    var hasLabel: Bool = true
    var labelText: String?
    var placeholder: String
    @Binding var fieldToDisplay: String
        
    var body: some View {
        VStack(alignment: .leading) {
            
            if hasLabel {
            Text(self.labelText != nil ? self.labelText! : "Text")
                .font(.title3)
                .bold()
                .opacity(self.labelText != nil ? 1 : 0)
            }
            
            TextField(self.placeholder, text: $fieldToDisplay)
                .font(.title2)
                .padding(8.5)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(Color.gray)
                        .background(
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(Color.white)
                        )
                )
        }
        .padding(0)
    }
}

struct ProfileDropDownPlaceholder: View {
    var labelText: String?
    var placeholder: String
    var valueToDisplay: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(self.labelText != nil ? self.labelText! : "Text")
                .font(.title3)
                .bold()
                .opacity(self.labelText != nil ? 1 : 0)
        
            HStack(spacing: 0) {
                if self.valueToDisplay != nil && self.valueToDisplay != "" {
                    Text(self.valueToDisplay!)
                        .font(.title2)
                } else {
                    Text(self.placeholder != "" ? self.placeholder : "Text")
                        .opacity(self.placeholder != "" ? 0.2 : 0)
                        .font(.title2)
                }

                Spacer()
                
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 12, height: 7)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
            .padding(8.5)
            .background(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(Color.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(Color.white)
                    )
            )

        }
        .padding(0)
    }
}

struct StatesPicker: View {
    @Binding var adult: Adult
    @Binding var presentationMode: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Save", action: {
                    withAnimation {
                        self.presentationMode.toggle()
                    }
                })
            }
            
            Picker(selection: $adult.state, label: Text("State")) {
                ForEach(statesDict, id: \.key) { key, value in
                    Text(value)
                }
            }
        }
        .frame(height: 240)
        .padding()
        .background(Color.white)
        .shadow(color: Color.gray, radius: 10.0)
    }
}

struct PhoneTypePicker: View {
    @Binding var adult: Adult
    @Binding var presentationMode: PhoneIndicator
        
    private let types: [PhoneType] = [ .Cell, .Work, .Landline ]
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

            Picker(selection: self.presentationMode == .Phone1 ? $adult.phone1Type : Binding($adult.phone2Type, replacingNilWith: .NilValue),
                   label: Text("Phone Type")) {
                ForEach(types, id: \.self) { type in
                    Text(type.description)
                }
            }
        }
        .frame(height: 240)
        .padding()
        .background(Color.white)
        .shadow(color: Color.gray, radius: 10.0)
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(adult: .constant(.default))
    }
}
