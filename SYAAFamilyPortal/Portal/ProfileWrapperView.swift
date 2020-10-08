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
        NavigationView {
            VStack {
                if adult != nil {
                    AdultProfileEditView(adult: Binding($adult,
                                                        replacingNilWith: Adult.default))
                        .onDisappear {
                            saveData()
                        }
                } else if student != nil {
                    // TODO: Create Student Profile and insert here.
                } else {
                    // TODO: Handle this error for user. (Shouldn't ever happen...)
                    Text("No user data found.")
                }
            }
            .navigationBarItems(trailing: Button("Log Out") {
                saveData()
                self.portal.logout()
            })
        }
    }
    
    private func saveData() {
        if portal.isLoggedIn {
            if self.adult != nil {
                _ = portal.updatePersonUsing(adult!)
            } else if self.student != nil {
                _ = portal.updatePersonUsing(student!)
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
