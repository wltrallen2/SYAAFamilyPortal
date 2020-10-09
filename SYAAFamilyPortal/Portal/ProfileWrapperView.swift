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
    
    var body: some View {
            VStack {
                if adult != nil {
                    AdultProfileEditView(adult: Binding($adult,
                                                        replacingNilWith: Adult.default))
                } else if student != nil {
                    StudentProfileEditView(student: Binding($student,
                                                            replacingNilWith: Student.default))
                } else {
                    // TODO: Handle this error for user. (Shouldn't ever happen...)
                    Text("No user data found.")
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
                print("Updating Adult")
                _ = portal.updatePersonUsing(adult!)
            } else if self.student != nil {
                print("Updating Student")
                _ = portal.updatePersonUsing(student!)
            } else {
                print("Updating No One")
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
