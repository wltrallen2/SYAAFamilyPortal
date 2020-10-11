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
    @State var selection: HomeTabs
    
    var body: some View {
        // TODO: Remove this old code. Better solution found.
//        if portal.adult == nil && portal.student == nil {
//            EmptyView() // This is necessary to avoid a crash upon logging out as environmentObject portal is updating variables.
//        } else {
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
//    }
}

struct HomeTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabbedView(selection: .Profile)
            .environmentObject(Portal())
    }
}
