//
//  PortalCustomViews.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import SwiftUI

struct ProfileTextField: View {
    var hasLabel: Bool = true
    var labelText: String?
    var placeholder: String
    @Binding var fieldToDisplay: String
        
    var body: some View {
        VStack(alignment: .leading) {
            
            if hasLabel {
            Text(self.labelText != nil ? self.labelText! : "Text")
                .portalLabelStyle(opacity: self.labelText == nil ? 0 : 1)
            }
            
            TextField(self.placeholder, text: $fieldToDisplay)
                .portalFieldStyle()
        }
        .padding(0)
    }
}

struct PickerPlaceholder: View {
    var labelText: String?
    var placeholder: String
    var valueToDisplay: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(self.labelText != nil ? self.labelText! : "Text")
                .portalLabelStyle(opacity: self.labelText == nil ? 0 : 1)
            
            HStack(spacing: 0) {
                if self.valueToDisplay != nil && self.valueToDisplay != "" {
                    Text(self.valueToDisplay!)
                } else {
                    Text(self.placeholder != "" ? self.placeholder : "Text")
                        .opacity(self.placeholder != "" ? 0.2 : 0)
                }

                Spacer()
                
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 12, height: 7)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
            .portalFieldStyle()

        }
        .padding(0)
    }
}


struct PortalCustomViews_Previews: PreviewProvider {
    @State static var field = "Information"
    
    static var previews: some View {
        Group {
            ProfileTextField(hasLabel: true,
                             labelText: "Field:",
                             placeholder: "Data",
                             fieldToDisplay: $field)
        }
    }
}
