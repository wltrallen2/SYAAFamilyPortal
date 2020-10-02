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
    @State private var selection: HomeTabs = .Profile
    
    var body: some View {
        TabView(selection: $selection){
            RehearsalsView()
                .tabItem {
                    Image(systemName: "calendar.circle.fill")
                    Text("Rehearsals")
                }
                .tag(HomeTabs.Rehearsals)
            
            ProfileWrapperView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("User Profile")
                }
                .tag(HomeTabs.Profile)
        }
    }
}

struct HomeTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabbedView()
            .environmentObject(Portal())
    }
}
