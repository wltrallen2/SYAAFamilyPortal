//
//  CustomButton.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/7/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

enum ButtonStyle {
    case Traditional
    case TextOnly
}

struct CustomButton: View {
    var style: ButtonStyle?
    var action: () -> Void
    var labelString: String

    var body : some View {
        VStack {
            if style == nil || style == .Traditional {
                Button(action: self.action) {
                    HStack {
                        Text(self.labelString)
                            .fontWeight(.medium)
                    }
                }
                .buttonStyle(CustomButtonStyle())

            } else if style == .TextOnly {
                Button(action: self.action) {
                    Text(self.labelString)
                        .multilineTextAlignment(.center)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(16)
                .foregroundColor(Color.blue)
            }
        }
    }
}

struct CustomButtonStyle: SwiftUI.ButtonStyle {
    var bgColor: Color = .blue
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(16)
            .foregroundColor(Color.lightGray)
            .background(bgColor)
            .cornerRadius(10)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        CustomButton(style: .Traditional, action: {}, labelString: "Hi!")
            .previewLayout(.sizeThatFits)
            
        CustomButton(style: .TextOnly, action: {}, labelString: "Hi!")
                .previewLayout(.sizeThatFits)
        }
    }
}
