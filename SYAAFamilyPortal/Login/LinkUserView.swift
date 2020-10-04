//
//  LinkUserView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/3/20.
//

import SwiftUI

struct LinkUserView: View {
    @EnvironmentObject var portal: Portal
    
    @State var code: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("LinkUserView")
            
            TextField("Linking Code", text: $code)
                .padding()
            
            Button("Link with Success") {
                _ = self.portal.selectPerson(usingLinkingCode: self.code)
            }
            
            Button("Link with Failure") {}
        }
    }
}

struct LinkUserView_Previews: PreviewProvider {
    static var previews: some View {
        LinkUserView()
            .environmentObject(Portal())
    }
}
