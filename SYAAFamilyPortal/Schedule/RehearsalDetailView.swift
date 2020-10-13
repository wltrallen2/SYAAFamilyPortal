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
                    otherCharacters: getOtherCharsCalled(),
                    myCharacters: getMyCharsCalled())
            } else if viewMode == .Actors {
                ActorListView(
                    otherCast: getOtherCastCalled(),
                    myCast: getMyCastCalled())
            }
            
            // TODO: Continue developing here.
            Spacer()
        }
        .padding(16)
        .navigationTitle("Schedule Detail")
    }
    
    func getOtherCharsCalled() -> [Character] {
        return getOtherCastCalled().map{ cast in
            return cast.character
        }.removingDuplicates().sorted(by: {(a, b) in
            a.name < b.name
        })
    }
    
    func getMyCharsCalled() -> [Character] {
        return getMyCastCalled().map{ cast in
            return cast.character
        }.removingDuplicates().sorted(by: {(a, b) in
            a.name < b.name
        })
    }
    
    // FIXME: There has to be a cleaner way of doing this.
    func getOtherCastCalled() -> [Cast] {
        let rehearsalCast = portal.getCastForRehearsal(rehearsal)

        var otherCastCalled = [Cast]()
        for cast in rehearsalCast {
            if !students.contains(where: {student in
                return student.id == cast.student.id
            })
            && !otherCastCalled.contains(cast) {
                
                otherCastCalled.append(cast)
                
            }
        }
        
        return otherCastCalled
    }
    
    func getMyCastCalled() -> [Cast] {
        let rehearsalCast = portal.getCastForRehearsal(rehearsal)
        
        var myCastCalled = [Cast]()
        for cast in rehearsalCast {
            // TODO: Check after connected to database. Here, had to replace cast.student object with original student object to make sure that any changes to name or profileColor in profile object were reflected here. (They are loaded from two different data sources locally.)
            if let student = students.first(where: {student in
                return cast.student.id == student.id
            }) {
                if !myCastCalled.contains(cast) {
                    let newCast = Cast(id: cast.id,
                                       student: student,
                                       character: cast.character,
                                       castName: cast.castName)
                    myCastCalled.append(newCast)
                }
            }
        }
        
        return myCastCalled
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
                                       color: student.profileColor)
                                .frame(width: 120)
                                .scaleEffect(0.75)
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
    static var previews: some View {
        RehearsalDetailView(rehearsal: Production.default.rehearsals[0],
                            students: [Production.default.cast[0].student])
            .environmentObject(Portal())
    }
}
