//
//  TabView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

enum HomeTabs: Int {
    case Rehearsals = 1
    case Profile = 2
}

struct HomeTabbedView: View {
    @EnvironmentObject var portal: Portal
    @State private var selection: HomeTabs = .Profile
    
    var body: some View {
        if portal.adult == nil && portal.student == nil {
            EmptyView() // This is necessary to avoid a crash upon loggin out as environmentObject portal is updating variables. TODO: Research to see if there's a better solution, and handle this better for user.
        } else {
            TabView(selection: $selection){
                RehearsalsView()
                    .tabItem {
                        Image(systemName: "calendar.circle.fill")
                        Text("Rehearsals")
                    }
                    .tag(HomeTabs.Rehearsals)
                
                NavigationView {
                    ProfileWrapperView(adult: portal.adult,
                                       student: portal.student)
                }
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("User Profile")
                }
                .tag(HomeTabs.Profile)
            }
        }
    }
}

struct HomeTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabbedView()
            .environmentObject(Portal())
    }
}
