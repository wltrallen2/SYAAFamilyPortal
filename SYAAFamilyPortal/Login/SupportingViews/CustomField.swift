//
//  CustomField.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/7/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

enum FieldType {
    case TextField
    case SecureField
}

struct CustomField: View {
    var label: String?
    var fieldType: FieldType
    var iconName: String?
    var placeholder: String
    var foregroundColor: Color = .blue
    @Binding var text: String

    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            if label != nil {
                Text(label!)
            }
            
            HStack {
                if iconName != nil {
                    Image(systemName: iconName!)
                        .foregroundColor(Color.gray)
                        .imageScale(.large)
                }

                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(Color.gray)
                    }
                    
                    if fieldType == .TextField {
                        TextField("", text: $text)
                            .foregroundColor(foregroundColor)
                            .autocapitalization(.none)
                    } else if fieldType == .SecureField {
                        SecureField("", text: $text)
                            .foregroundColor(foregroundColor)
                            .autocapitalization(.none)
                    }
                }
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.white))
        }
    }
}


#if DEBUG
struct CustomField_PreviewContainer : View {
    @State private var moreText: String = "Here's a Value"
    @State private var text: String = ""
    @State private var nextText: String = ""

    var body: some View {
        Group {
            CustomField(label: "Field Label", fieldType: .TextField, iconName: nil, placeholder: "Enter text", foregroundColor: Color.black, text: $moreText)
            
            CustomField(fieldType: .TextField, iconName: "person.circle.fill", placeholder: "Enter text", text: $text)
            
            CustomField(fieldType: .TextField, iconName: nil, placeholder: "Something without an icon", text: $nextText)
        }
    }
}

struct CustomField_Previews: PreviewProvider {

    static var previews: some View {
        CustomField_PreviewContainer()
            .previewLayout(.sizeThatFits)
    }
}
#endif
