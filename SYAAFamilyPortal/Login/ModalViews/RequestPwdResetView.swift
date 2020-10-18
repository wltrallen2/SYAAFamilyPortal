//
//  ForgotPasswordView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/8/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

struct RequestPwdResetView: View {
    @EnvironmentObject var portal: Portal
    @State private var email: String = ""
    @Binding var emailSent: Bool
    
    var body: some View {        
        VStack (spacing: 0){
            Group {
                VStack {
                    
                    Image(systemName: "lock.shield.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.blue)
                        .frame(width: 50, height: 50, alignment: .center)

                    CustomText(text: Constants.Content.ForgotPwdInfoString,
                               textType: .Bold)
                        .multilineTextAlignment(.center)
                        .allowsTightening(true)
                    
                    CustomField(fieldType: .TextField,
                                iconName: "envelope.circle.fill",
                                placeholder: "Email",
                                text: $email)
                    
                    CustomButton(style: .Traditional,
                                 action: {
                                    portal.requestPwdReset(
                                        forUserWithEmail: email,
                                        onCompletion: { success in
                                            self.emailSent = success
                                        })
                                 },
                                 labelString: "Send Reset Instructions")
                    
                    CustomErrorArea(message: portal.error)
                }
                .padding(24)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.lightGray)
        }
    }
}

struct RequestPwdResetView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordParentView()
            .environmentObject(Portal())
            .statusBar(hidden: false)
    }
}
