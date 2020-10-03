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
    @State var draftPerson: Person = Person.default
    
    var body: some View {
        NavigationView {
            VStack {
                if (portal.person) != nil && portal.person!.adult != nil {
                    AdultProfileEditView(person: $draftPerson, adult: Binding($draftPerson.adult, replacingNilWith: Adult.default))
                        .onAppear {
                            self.draftPerson = self.portal.person!
                        }
                        .onDisappear {
                            self.portal.person! = self.draftPerson
                            print(self.portal.person!)
                        }
                } else { // TODO: Create Student Profile and insert here.
                    Text("No adult data found.")
                }
            }
            .navigationTitle(Text("User Profile"))
        }
    }
}

struct ProfileWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileWrapperView()
            .environmentObject(Portal())
    }
}
