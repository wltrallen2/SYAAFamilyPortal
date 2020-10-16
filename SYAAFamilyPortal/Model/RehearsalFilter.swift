//
//  RehearsalFilter.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/16/20.
//

import Foundation
import Combine

class RehearsalFilter: ObservableObject {
    let didChange = PassthroughSubject<[Rehearsal], Never>()
    
    var portal: Portal
    var rehearsals: [Rehearsal]
    var filteredRehearsals: [Rehearsal] {
        get {
            var filtered = [Rehearsal]()
            for student in selectedStudents {
                let myChars = portal.getAllCharacterIdsForStudent(student)
                filtered.append(contentsOf: rehearsals.filter({ rehearsal in
                    !filtered.contains(rehearsal)
                        && rehearsal.characterIds.contains(where: { charId in
                            myChars.contains(where: { $0 == charId })
                    })
                }))
            }
            
            if showAllOtherStudents {
                var myChars = [Int]()
                for student in portal.getMyStudents() {
                    myChars.append(contentsOf: portal.getAllCharacterIdsForStudent(student))
                }
                
                print("\(myChars)")
                filtered.append(contentsOf: rehearsals.filter({ rehearsal in
                    !filtered.contains(rehearsal)
                        && !rehearsal.characterIds.contains(where: { charId in
                            myChars.contains(where: { $0 == charId })
                    })
                }))
            }
            
            // NEXT: Finish implementing computed value
            
            return filtered.sorted(by: {(a, b) in
                a.start < b.start
            })
        }
    }
    
    @Published var selectedStudents: [Student] {
        didSet {
            print("selected students changed")
            for student in selectedStudents { print("     - \(student.person.firstName)") }
            didChange.send(filteredRehearsals)
        }
    }
    
    @Published var showAllOtherStudents: Bool = true {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    
    @Published var withConflictsOnly: Bool = false {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    
    @Published var dateRange: Range<Date>? {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    

    init(portal: Portal) {
        self.portal = portal
        self.rehearsals = portal.productions.compactMap({ $0.rehearsals }).flatMap({ $0 })
        self.selectedStudents = portal.getMyStudents()
    }
}
