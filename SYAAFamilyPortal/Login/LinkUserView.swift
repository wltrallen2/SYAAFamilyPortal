//
//  LinkUserView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/3/20.
//

import SwiftUI

struct LinkUserView: View {
    @EnvironmentObject var portal: Portal
    
    @State var code: String = ""
    
    var body: some View {
        ZStack {
            Color.lightGray
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                MainHeader(subHeadImageString: "Text-LinkAccount")
                Spacer()
                
                CustomText(text: "Your login is not yet linked to an account.",
                           textType: .Italic)
                
                CustomText(text: Constants.Content.LinkAccountInstructionString,
                           textType: .Bold)
                Spacer()
                
                CustomField(fieldType: .TextField,
                            iconName: "number.circle.fill",
                            placeholder: "Link Code",
                            text: $code)

                                
                CustomButton(style: .Traditional,
                             action: {
                                _ = portal.selectPerson(usingLinkingCode: code)
                            },
                             labelString: "Link To My Account")
                
                CustomErrorArea(message: portal.error)
                    .padding(.top, 8)
                
            }
            .padding(16)
        }
    }
}

struct LinkUserView_Previews: PreviewProvider {
    static var previews: some View {
        LinkUserView()
            .environmentObject(Portal())
    }
}
