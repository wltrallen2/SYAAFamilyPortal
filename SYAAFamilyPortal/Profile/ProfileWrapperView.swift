//
//  ProfileHomeView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI
import AQUI

struct ProfileWrapperView: View {
    @EnvironmentObject var portal: Portal
    
    @State var adult: Adult?
    @State var student: Student?
    
    @State var showAlert: Bool = false
    @State var alertTitle: String = "Welcome to the SYAA Family Portal!"
    @State var alertMessage: String = "Please verify your profile information before continuing."
    
    var body: some View {
            VStack {
                if adult != nil {
                    AdultProfileEditView(adult: Binding($adult,
                                                        replacingNilWith: Adult.default))
                } else if student != nil {
                    StudentProfileEditView(student: Binding($student,
                                                            replacingNilWith: Student.default),
                                           alertTitle: $alertTitle,
                                           alertMessage: $alertMessage,
                                           showAlert: $showAlert)
                } else {
                    // TODO: Handle this error for user. (Shouldn't ever happen...)
                    Text("No user data found.")
                }
            }
            .alert(isPresented: $showAlert,
                   content: {
                    Alert(title: Text(alertTitle),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK"), action: {
                            self.showAlert = false;
                            if adult != nil { adult!.person.hasVerified.toggle()}
                            else if student != nil { student!.person.hasVerified.toggle() }
                            saveData()
                          }))
                   })
            .onAppear() {
                if adult != nil && adult! == portal.adult {
                    showAlert = !adult!.person.hasVerified
                } else if student != nil && student! == portal.student {
                    showAlert = !student!.person.hasVerified
                }
            }
            .onDisappear() {
                saveData()
            }
            .navigationBarItems(trailing: Button("Log Out") {
                saveData()
                self.portal.logout()
            })
    }
    
    private func saveData() {
        if portal.isLoggedIn {
            if self.adult != nil {
                portal.updatePersonUsing(adult!)
            } else if self.student != nil {
                portal.updatePersonUsing(student!)
            }
        }
    }
}

struct ProfileWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileWrapperView(adult: Adult.default)
            .environmentObject(Portal())
    }
}
