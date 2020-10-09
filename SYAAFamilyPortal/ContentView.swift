//
//  ContentView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var portal: Portal
    
    var body: some View {
        if !self.portal.isLoggedIn {
            LoginWrapperView()
        } else {
            if(!self.portal.user!.isLinked) {
                LinkUserView()
            } else {
                HomeTabbedView(selection: hasVerified() ? .Rehearsals : .Profile)
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
        ContentView()
            .environmentObject(Portal())
    }
}
