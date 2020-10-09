//
//  PickerViews.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import SwiftUI

struct StatesPicker: View {
    @Binding var state: String
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

struct PickerViews_Previews: PreviewProvider {
    @State static var adult: Adult = Adult.default
    
    static var previews: some View {
        Group {
            StatesPicker(state: $adult.state,
                         presentationMode: .constant(true))
                .previewLayout(.sizeThatFits)
            
            PhoneTypePicker(phoneType: $adult.phone1Type,
                            presentationMode: .constant(PhoneIndicator.Phone1))
                .previewLayout(.sizeThatFits)
        }
        
    }
}
