//
//  LoginView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/3/20.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var portal: Portal
    @Binding var currentView: LoginViewType
    
    @State var userToken: String = ""
    @State var password: String = ""
    
    @State var showForgot = false
    
    var body: some View {
        VStack (spacing: 16) {
            Text("Login View")
            
            Button("Login using Default User", action: {
                _ = self.portal.verifyUser("", withPassword: "")
            })
            
            VStack (spacing: 16) {
                TextField("Username", text: $userToken)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                Button("Login using these credentials", action: {
                    _ = self.portal.verifyUser(
                        self.userToken,
                        withPassword: self.password)
                })
            }.padding()
            
            Text(self.portal.error)
                .italic()
                .foregroundColor(Color.red)
            
            Button("Create New User") {
                self.currentView = .Create
            }
            
            Button("Forgot Password") {
                self.showForgot.toggle()
            }
        }.sheet(isPresented: $showForgot) {
            ForgotPasswordView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentView: .constant(.Verify))
            .environmentObject(Portal())
    }
}
