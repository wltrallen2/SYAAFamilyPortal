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
    @State var person: Person
    @State var adult: Adult
    
    var body: some View {
        NavigationView {
            VStack {
                if (portal.person) != nil && portal.person!.adult != nil {
                    AdultProfileEditView(person: $person, adult: Binding($person.adult, replacingNilWith: Adult.default))
                        .onAppear {
                            self.adult = self.portal.person!.adult!
                            self.person = self.portal.person!
                        }
                        .onDisappear {
                            if self.portal.isLoggedIn {
                                self.portal.person! = self.person
                                self.portal.person!.setAdult(self.adult)
                                print(self.portal.person!)
                            }
                        }
                } else { // TODO: Create Student Profile and insert here.
                    Text("No adult data found.")
                }
            }
            .navigationTitle(Text("User Profile"))
            .navigationBarItems(trailing: Button("Log Out") {
                self.portal.person? = self.person
                self.portal.logout()
            })
        }
    }
}

struct ProfileWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileWrapperView(person: Person.default,
                           adult: Adult.default)
            .environmentObject(Portal())
    }
}
