//
//  ContentView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

// NEXT: Connect to Database

// NEXT: Family disappears at bottom of home parent when home parent is edited. Might have to do with local data storage.

struct ContentView: View {
    @EnvironmentObject var portal: Portal
    
    var body: some View {
        if !self.portal.isLoggedIn {
            LoginWrapperView()
        } else {
            if(!self.portal.user!.isLinked) {
                LinkUserView()
            } else {
                HomeTabbedView(
                    selection: hasVerified() ? .Rehearsals : .Profile,
                    rehearsalFilter: RehearsalFilter(portal: portal))
            }
        }
    }
    
    private func hasVerified() -> Bool {
        var hasVerified = false
        
        if portal.adult != nil {
            hasVerified = portal.adult!.person.hasVerified
        } else if portal.student != nil {
            hasVerified = portal.student!.person.hasVerified
        }
        
        return hasVerified
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(Portal())
                .previewDevice("iPhone 8")
                .previewDisplayName("iPhone 8")
            
            ContentView()
                .environmentObject(Portal())
                .previewDevice("iPhone 11")
                .previewDisplayName("iPhone 11")

//            ContentView()
//                .environmentObject(Portal())
//                .previewDevice("iPhone 11 Pro Max")
//                .previewDisplayName("iPhone 11 Pro Max")
        }
    }
}
