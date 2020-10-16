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
    
    // Filter Variables
    @State private var showFilter: Bool = false
    @ObservedObject var rehearsalFilter: RehearsalFilter

    
    var body: some View {
        return ZStack (alignment: .topTrailing) {
            TabView(selection: $selection){
                    NavigationView {
                        RehearsalsView(
                            showFilter: $showFilter,
                            rehearsalFilter: rehearsalFilter)
                    }
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
            
            .disabled(showFilter ? true : false)
            .blur(radius: showFilter ? 5 : 0)
            
            if showFilter {
                SelectFilterView(
                    showFilter: $showFilter,
                    rehearsalFilter: rehearsalFilter)
                    .ignoresSafeArea(.container, edges: .top)
            }

        }
    }
}

struct HomeTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabbedView(selection: .Profile,
                       rehearsalFilter:
                        RehearsalFilter(portal: Portal()))
            .environmentObject(Portal())
    }
}
