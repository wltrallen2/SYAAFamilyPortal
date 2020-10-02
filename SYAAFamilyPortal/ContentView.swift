//
//  ContentView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeTabbedView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Portal())
    }
}
