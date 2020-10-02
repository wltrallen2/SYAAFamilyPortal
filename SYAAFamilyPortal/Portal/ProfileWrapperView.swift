//
//  ProfileHomeView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

struct ProfileWrapperView: View {
    @EnvironmentObject var portal: Portal
    @State var draftAdult: Adult = Adult.default
    
    var body: some View {
        NavigationView {
            VStack {
                if (portal.adult) != nil {
                    ProfileEditView(adult: $draftAdult)
                        .onAppear {
                            self.draftAdult = self.portal.adult!
                        }
                        .onDisappear {
                            self.portal.adult! = self.draftAdult
                        }
                } else {
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
