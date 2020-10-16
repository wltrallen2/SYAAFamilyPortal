//
//  RehearsalDetailView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/11/20.
//

import SwiftUI

enum CallView {
    case Characters
    case Actors
}

struct RehearsalDetailView: View {
    @EnvironmentObject var portal: Portal
    @Binding var selection: RehearsalViewTag?
    var rehearsal: Rehearsal
    var students: [Student]
        
    @State private var viewMode: CallView = .Characters
    
    var body: some View {
        VStack {
            HStack {
                RehearsalDetails(rehearsal: rehearsal,
                                 students: students)
                
                Spacer()
            }
            
            Picker(selection: $viewMode, label: (Text("View"))) {
                Text("Characters Called").tag(CallView.Characters)
                Text("Actors Called").tag(CallView.Actors)
            }.pickerStyle(SegmentedPickerStyle())
            
            if viewMode == .Characters {
                CharacterListView(
                    otherCharacters: portal.getOtherCharactersForRehearsal(rehearsal),
                    myCharacters: portal.getMyCharactersForRehearsal(rehearsal))
            } else if viewMode == .Actors {
                ActorListView(
                    otherCast: portal.getOtherCastForRehearsal(rehearsal),
                    myCast: portal.getMyCastForRehearsal(rehearsal))
            }
            
            Spacer()
        }
        .padding(16)
        .navigationTitle("Schedule Detail")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                HStack {
                    Button(action: {
                        self.selection = .NilValue
                    }, label: {
                        Label("Back", systemImage: "chevron.left")
                    })
                }
        )
    }
}

struct RehearsalDetails: View {
    @EnvironmentObject var portal: Portal
    var rehearsal: Rehearsal
    var students: [Student]
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                HStack {
                    if(students.count > 0) {
                        ForEach(students, id:\.id) { student in
                            StudentTab(name: student.person.firstName,
                                       color: student.profileColor,
                                       conflict: portal.getConflictForStudent(student, atRehearsal: rehearsal))
                        }
                    }
                }
                .padding(.bottom, 12)
                
                Text(portal.getProductionTitleForRehearsal(rehearsal) ?? "Title")
                    .font(.caption).bold()
                Text(portal.getRehearsalDateStringForRehearsal(rehearsal))
                    .font(.title2).fontWeight(.heavy)
                Text(portal.getRehearsalTimeStringForRehearsal(rehearsal))
                    .font(.title3).fontWeight(.bold)
                Text(rehearsal.description)
                    .font(.body).fontWeight(.light)
                    .padding(.vertical, 8)
            }
            
            Spacer()
        }
    }
}

struct RehearsalDetailView_Previews: PreviewProvider {
    @State static var selection: RehearsalViewTag? = .RehearsalDetail
    static var previews: some View {
        NavigationView {
            RehearsalDetailView(
                selection: $selection,
                rehearsal: Production.default.rehearsals[0],
                                students: [Portal().otherStudents[0]])
                .environmentObject(Portal())
        }
    }
}
