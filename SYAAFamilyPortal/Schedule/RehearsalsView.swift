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
                    NavigationLink(destination:
                                    RehearsalDetailView(
                                        rehearsal: rehearsal,
                                        students: portal.getStudentsForRehearsal(rehearsal))) {
                        RehearsalTab(rehearsal: rehearsal,
                                     students: portal.getStudentsForRehearsal(rehearsal))
                            .padding(-4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .navigationTitle("Rehearsal Schedule")
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
