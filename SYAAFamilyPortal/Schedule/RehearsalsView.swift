//
//  RehearsalsView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import SwiftUI

struct RehearsalsView: View {
    @EnvironmentObject var portal: Portal
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(self.getAllRehearsals(), id:\.id) { rehearsal in
                    RehearsalTab(rehearsal: rehearsal)
                        .padding(-4)
                }
            }
        }
    }
    
    func getAllRehearsals() -> [Rehearsal] {
        var rehearsals: [Rehearsal] = []
        
        for production in portal.productions {
            rehearsals.append(contentsOf: production.rehearsals)
        }
        
        return rehearsals
    }
}

struct RehearsalsView_Previews: PreviewProvider {
    static var previews: some View {
        RehearsalsView()
            .environmentObject(Portal())
    }
}
