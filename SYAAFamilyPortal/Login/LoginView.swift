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
        // FIXME: Add spinner while waiting for login.
        ZStack {
            Color.lightGray
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                MainHeader()
                Spacer()
                
                VStack(spacing: 1) {
                    CustomField(fieldType: .TextField,
                                iconName: "person.circle.fill",
                                placeholder: "Username",
                                text: $userToken)
                    
                    CustomField(fieldType: .SecureField,
                                iconName: "lock.circle.fill",
                                placeholder: "Password",
                                text: $password)
                }
                
                CustomButton(action: {
                    _ = portal.verifyUser(userToken,
                                      withPassword: password)
                },
                             labelString: "Sign In")
                
                CustomErrorArea(message: portal.error)
                    .padding(.top, 8)
                
                VStack (spacing: -8) {
                    CustomButton(style: .TextOnly,
                                 action: {
                                    portal.error = ""
                                    showForgot.toggle()
                                 },
                                 labelString: "Forgot your password?")
                        .sheet(isPresented: self.$showForgot) {
                            ForgotPasswordParentView() // FIXME
                        }

                    CustomButton(style: .TextOnly,
                                 action: {
                                    portal.error = ""
                                    self.currentView = .Create
                                 },
                                 labelString: "Don't have an account? Sign up.")
                }
            }
            .padding(16)
        }
    }

//    var body: some View {
//        VStack (spacing: 16) {
//            Text("Login View")
//            
//            Button("Login using Default Adult User", action: {
//                _ = self.portal.verifyUser("cook", withPassword: "password")
//            })
//            
//            Button("Login using Default Student User", action: {
//                _ = self.portal.verifyUser("ak", withPassword: "password")
//            })
//
//            VStack (spacing: 16) {
//                TextField("Username", text: $userToken)
//                    .autocapitalization(.none)
//                SecureField("Password", text: $password)
//                    .autocapitalization(.none)
//                Button("Login using these credentials", action: {
//                    _ = self.portal.verifyUser(
//                        self.userToken,
//                        withPassword: self.password)
//                })
//            }.padding()
//            
//            Text(self.portal.error)
//                .italic()
//                .foregroundColor(Color.red)
//            
//            Button("Create New User") {
//                self.currentView = .Create
//            }
//            
//            Button("Forgot Password") {
//                self.showForgot.toggle()
//            }
//        }.sheet(isPresented: $showForgot) {
//            ForgotPasswordParentView()
//        }
//    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentView: .constant(.Verify))
            .environmentObject(Portal())
    }
}
