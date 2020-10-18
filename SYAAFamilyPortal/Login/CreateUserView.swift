//
//  CreateUserView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/3/20.
//

import SwiftUI

struct CreateUserView: View {
    @EnvironmentObject var portal: Portal
    @Binding var currentView: LoginViewType

    @State var userToken: String = ""
    @State var password: String = ""
    @State var passwordVerification: String = ""
    
    var body: some View {
        ZStack {
            Color.lightGray
                .edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 0){
                MainHeader(subHeadImageString: "Text-CreateAccount")
                    .scaledToFit()
                Spacer()
                
                VStack(spacing: 2) {
                    CustomField(fieldType: .TextField,
                                iconName: "person.circle.fill",
                                placeholder: "Choose a Username",
                                text: $userToken)
                    
                    CustomField(fieldType: .SecureField,
                                iconName: "lock.circle.fill",
                                placeholder: "Choose a password",
                                text: $password)
                    
                    CustomField(fieldType: .SecureField,
                                iconName: "lock.circle.fill",
                                placeholder: "Reenter your password to verify",
                                text: $passwordVerification)
                }
                
                CustomButton(style: .Traditional,
                             action: {
                                portal
                                    .createUser(
                                        userToken,
                                        withPassword: password,
                                        andVerificationPassword: passwordVerification)
                             },
                             labelString: "Register Now")
                
                CustomErrorArea(message: portal.error)
                    .padding(.top, 8)
                
                VStack {
                    CustomButton(style: .TextOnly,
                                 action: {
                                    portal.error = ""
                                    currentView = .Verify
                                },
                                 labelString: "I already have an account.\n Return to Login.")
                }
            }
            .scaledToFit()
            .padding(16)
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(currentView: .constant(.Create))
            .environmentObject(Portal())
    }
}
