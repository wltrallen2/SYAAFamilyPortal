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
        VStack (spacing: 16) {
            Text("Create User View")
            
            TextField("Username", text: $userToken)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
            SecureField("Verify Password", text: $passwordVerification)
                .autocapitalization(.none)
            
            Button("Register as New User", action: {
                _ = self.portal.createUser(
                    self.userToken,
                    withPassword: self.password,
                    andVerificationPassword: self.passwordVerification)
            })
            
            Button("Return to Login Screen") {
                self.currentView = .Verify
            }
        }
        .padding()
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(currentView: .constant(.Create))
            .environmentObject(Portal())
    }
}
