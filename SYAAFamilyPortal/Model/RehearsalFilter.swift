//
//  RehearsalFilter.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/16/20.
//

import Foundation
import Combine

enum ShowConflicts {
    case All
    case With
    case Without
    case None
}

class RehearsalFilter: ObservableObject {
    let didChange = PassthroughSubject<[Rehearsal], Never>()
    
    var portal: Portal
    var rehearsals: [Rehearsal]
    var filteredRehearsals: [Rehearsal] {
        get {
            if withConflicts == .None { return [] }
            
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
            
            let myStudents = portal.getMyStudents()
            if showAllOtherStudents {
                var myChars = [Int]()
                for student in myStudents {
                    myChars.append(contentsOf: portal.getAllCharacterIdsForStudent(student))
                }
                
                filtered.append(contentsOf: rehearsals.filter({ rehearsal in
                    !filtered.contains(rehearsal)
                        && !rehearsal.characterIds.contains(where: { charId in
                            myChars.contains(where: { $0 == charId })
                    })
                }))
            }
            
            return filtered
                .filter({ rehearsal in
                self.startDate <= rehearsal.start
                    && rehearsal.start <= self.endDate
                }).filter({ rehearsal in
                    if withConflicts == .Without {
                        //                        if selectedStudents.count == myStudents.count {
                        //                            return portal.familyConflicts.filter({ conflict in
                        //                                conflict.rehearsalId == rehearsal.id
                        //                            }).count != myStudents.count
                        //                        } else {
                        
                        let myIds = selectedStudents
                            .compactMap({ $0.person.id })
                            .sorted(by: { (a, b) in a < b })
                        
                        let studentIds: [Int] = portal.familyConflicts.filter({ conflict in
                            conflict.rehearsalId == rehearsal.id
                                && myIds.contains(conflict.studentId)
                        })
                        .compactMap({ $0.studentId })
                        .sorted(by: {(a, b) in a < b })
                        
                        return !studentIds
                            .elementsEqual(myIds)
                        //                        }
                    } else if withConflicts == .With {
                        return portal.familyConflicts.contains(where: { conflict in
                            conflict.rehearsalId == rehearsal.id
                        })
                    }
                    
                    // else .All
                    return true
                }).removingDuplicates().sorted(by: {(a, b) in
                a.start < b.start
            })
        }
    }
    
    @Published var selectedStudents: [Student] {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    
    @Published var showAllOtherStudents: Bool = true {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    
    @Published var withConflicts: ShowConflicts = .All {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    
    @Published var startDate: Date {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    
    @Published var endDate: Date {
        didSet {
            didChange.send(filteredRehearsals)
        }
    }
    
    var showAll: Bool {
        get {
            self.startDate == rehearsals.first?.start
                && self.endDate == rehearsals.last?.start
        }
    }
    

    init(portal: Portal) {
        self.portal = portal
        self.rehearsals = portal.productions
            .compactMap({ $0.rehearsals })
            .flatMap({ $0 })
            .sorted(by: { (a, b) in a.start < b.start })
        
        self.selectedStudents = portal.getMyStudents()
        self.startDate = rehearsals.first?.start ?? Date()
        self.endDate = rehearsals.last?.start ?? Date()
    }
    
    func resetDateRange() {
        self.startDate = rehearsals.first?.start ?? Date()
        self.endDate = rehearsals.last?.start ?? Date()
    }
    
    func clearFilter() {
        self.selectedStudents = portal.getMyStudents()
        self.showAllOtherStudents = true
        self.startDate = rehearsals.first?.start ?? Date()
        self.endDate = rehearsals.last?.start ?? Date()
        self.withConflicts = .All
    }
}
