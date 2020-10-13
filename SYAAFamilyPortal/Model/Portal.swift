//
//  Portal.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import Foundation

class Portal: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var error: String = ""
    
    private lazy var db: PortalDatabase = PortalDatabase()
    
    @Published var user: User? {
        didSet {
            if user != nil {
                self.setProductions()
            }
        }
    }
    @Published var adult: Adult? {
        didSet {
            if self.adult != nil {
                self.fetchFamily()
            }
        }
    }
    @Published var student: Student?
    
    @Published var family: [Personable] = [Production.default.cast[0].student, Student.default, Student.default, Adult.default, Adult.default]
    
    // NEXT: Refractor so that productions, rehearsals, otherStudents are all published items even though they won't be changed.
    // NEXT: Refractor so that productions has a list of characters, not cast elements.
    // NEXT: Refractor so that conflicts are all published items that can be changed.
    // NEXT: Refractor cast to use character and student ids
    @Published var productions: [Production] = [Production.default]
        
    //**********************************************************************
    // MARK: - USER FUNCTIONS
    //**********************************************************************
    
    func logout() {
        self.user = nil
        self.adult = nil
        self.student = nil
        self.family = []
        self.productions = []
        self.error = ""
        self.isLoggedIn = false
    }
    /**
     Logs in a user based on their userToken and password combination.
     
     If the user is valid, sets isLoggedIn to true and sets the user variable with the appropriate information. Then, if the user is linked, the method will call the loadDataForUser method. Upon success, returns true.
     
     If the user is not valid, sets isLoggedIn to false, sets the current user error message, and returns false.
     */
    func verifyUser(_ userToken: String, withPassword pwd: String) -> Bool {
        var success = false
        
        // TODO: Implement this function.
        // FIXME: Temporary implementation
        var tempToken = userToken
        var tempPwd = pwd
        if tempToken == "" {
            tempToken = "wltrallen2"
            tempPwd = "password"
        }
        let users: [User] = db.load("userData.json") // Load local data for users
        let userIterator = users.makeIterator()
        
        if let validUser = userIterator.first(where: { user -> Bool in
            return user.userToken == tempToken
                && tempPwd == "password"
        }) {
            self.user = validUser
            self.isLoggedIn = true
            
            if(self.user!.isLinked) {
                _ = self.selectPersonForUser(self.user!)
            }
            
            success = true
        } else {
            self.error = "The username/password combination you entered does not appear in our database."
        }
        
        return success
    }
    
    /**
     If the two password parameters match, create a new user based on the userToken and password provided.
     
     If successful, set isLoggedIn to true, set the user variable with the appropriate information, and return true. NOTE: The user will never be linked if their account has just been created. Therefore, no call to load person data is made from this function.
     
     If not valid, set isLoggedIn to false, set the current user error message, and return false.
     */
    func createUser(_ userToken: String, withPassword pwd: String, andVerificationPassword pwd2: String) -> Bool {
        // TODO: Implement this function.
        // FIXME: Temporary implementation
        let users: [User] = db.load("userData.json")
        let count = users.count
        
        let user = User(id: count + 1, userToken: userToken, isLinked: false)
        db.insert(codableObject: user,
                  intoArray: users,
                  usingFileWithName: "userData.json")
        
        self.user = user
        self.isLoggedIn = true
        return true
    }
    
    /**
     Through the API, handle the password reset request and return true. Return false if the request fails.
     
     NOTE: The API currently only resets the password for adult users since only adult users are required to have email addresses on file. For the future, implement an option that accepts a userToken instead. This will also allow for users to have more than one userToken tied to their account.
     */
    // FIXME: Implement a version of this function that allows users to reset their password using their userToken, not their email. This will allow for students to reset their password as well.
    func requestPwdReset(forUserWithEmail email: String) -> Bool {
        // TODO: Implement this function.
        return true
    }
    
    //**********************************************************************
    // MARK: - PERSON FUNCTIONS
    //**********************************************************************
    
    /**
     Using the userId, queries the API to select the user information and sets the primary user for this session. If successful, returns true. If unsuccessful, sets the current user error message and returns false.
     */
    func selectPersonForUser(_ user: User) -> Bool {
        // TODO: Implement this function
        var success = false
        
        guard self.user != nil else {
            fatalError("No user logged in.")
        }
        
        if !self.user!.isLinked {
            self.error = "User has not been linked to person accoutn yet"
            return false
        }
        
        // TODO: Implement this function
        let links: [[String: Int]] = db.load("userPersonLinksData.json")
        
        let link = links.first(where: { link -> Bool in
            return link["userId"] == self.user!.id
        })
        
        let adults: [Adult] = db.load("adultData.json")
        let students: [Student] = db.load("studentData.json")
        
        if let personId = link?["personId"] {
            self.adult = adults.first(where: { adult -> Bool in
                return adult.id == personId
            })
            
            if self.adult == nil {
                self.student = students.first(where: { student -> Bool in
                    return student.id == personId
                })
            }
            
            success = self.adult != nil || self.student != nil
        }
        
        return success
    }
    
    /**
     Using the userId and the linking code, queries the API to link the user to a person and then sets the primary user for this session based off of the response data. If successful, returns true. Else, sets the current user error message and returns false.
     */
    func selectPerson(usingLinkingCode code: String) -> Bool {
        var success = false
        
        guard self.user != nil else {
            fatalError("No user logged in.")
        }
        
        // TODO: Implement this function
        let links: [[String: Int]] = db.load("userPersonLinksData.json")
        
        let link = links.first(where: { link -> Bool in
            return link["userId"] == self.user!.id
        })
        
        let adults: [Adult] = db.load("adultData.json")
        if let personId = link?["personId"] {
            self.adult = adults.first(where: { adult -> Bool in
                return adult.id == personId
            })
            
            if self.adult == nil {
                let students: [Student] = db.load("studentData.json")
                self.student = students.first(where: { student -> Bool in
                    return student.id == personId
                })
            }
        
            if self.adult != nil || self.student != nil {
                self.user!.isLinked = true
                let users: [User] = load("userData.json")
                db.insert(codableObject: self.user!,
                          intoArray: users,
                          usingFileWithName: "userData.json")
                
                success = true
            }
        
        }
        
        return success
    }
    
    /**
     Updates the database with the given person information. Returns true on success. Else, sets the current user error message and returns false.
     */
    func updatePersonUsing(_ person: Personable) -> Bool {
        // TODO: Implement this function
        var success = false
        
        // FIXME: Temporary Implementation
        if person is Adult {
            var adults: [Adult] = db.load("adultData.json")
            adults.removeAll(where: { adult -> Bool in
                return adult.id == person.id
            })
            
            adults.append(person as! Adult)
            db.save(encodableObject: adults, toFileWithName: "adultData.json")
            
            success = true
        } else if person is Student {
            var students: [Student] = db.load("studentData.json")
            students.removeAll(where: { student -> Bool in
                return student.id == person.id
            })
            
            students.append(person as! Student)
            db.save(encodableObject: students, toFileWithName: "studentData.json")
            
            success = true
        }
        
        if adult?.id == person.id { adult = person as? Adult}
        else if student?.id == person.id { student = person as? Student }
        else if(family.contains(where: { familyMember in
                return familyMember.id == person.id
            })) {
            
            family.removeAll(where: { familyMember in
                return familyMember.id == person.id
            })
            family.append(person)
        }
        
        return success
    }
    
    func fetchFamily() {
        // TODO: Implement this function.
        guard let adultId = self.adult?.person.id else { return }
        self.family.removeAll()
        
        // FIXME: Temporary Implementation
        let families: [[Int]] = db.load("familyLinksData.json")
        var ids = families.first(where: { ids -> Bool in
            return ids.contains(adultId)
        })
        
        if ids == nil { return }
        if ids!.count <= 1 { return }
        
        let adults: [Adult] = db.load("adultData.json")
        let students: [Student] = db.load("studentData.json")
        
        ids!.removeAll(where: {id in
            return id == adultId
        })
        
        for id in ids! {
            var person: Personable? = adults.first(where: { adult in
                return adult.id == id
            })
            
            if person == nil {
                person = students.first(where: { student in
                    return student.id == id
                })
            }
            
            if person != nil { self.family.append(person!) }
        }
    }
    
    func getFamilyMembersOfType<T: Personable>(_ type: T.Type) -> [T] {
        var members: [T] = []
        for person in self.family {
            if person is T {
                let member = person as! T
                members.append(member)
            }
        }
                
        return members.sorted(by: { a, b in
            return a.person.firstName < b.person.firstName
        })
    }
    
    //**********************************************************************
    // MARK: - PRODUCTION FUNCTIONS
    //**********************************************************************
    
    func setProductions() {
        // FIXME: Temporary Implementation
        productions = db.load("productionData.json");
    }
    
    func getProductionForRehearsal(_ rehearsal: Rehearsal) -> Production? {
        let pid = rehearsal.productionId
        return self.productions.first(where: { production in
            return production.id == pid
        }) ?? nil
    }
    
    func getStudentsForRehearsal(_ rehearsal: Rehearsal) -> [Student] {
        var students: [Student] = []
        
        // Get a list of students, either a list of one student (me) for student user or a list of students in my family for adult user.
        let myStudents = self.student != nil
            ? [ self.student! ]
            : self.getFamilyMembersOfType(Student.self)
        
        // Get the production and a list of all castings for that production
        guard let production = self.getProductionForRehearsal(rehearsal) else { return [] }
        let casting = production.cast
        
        // For each student in the myStudents list, find all castings for that student, and for each casting, if the character is called to this rehearsal, add the student to the students array if they are not added already.
        for student in myStudents {
            let castings = casting.filter({ casting in
                return student.id == casting.student.id
            })
            
            for c in castings {
                if rehearsal.characterIds.contains(c.character.id)
                    && !students.contains(where: {s in
                        return s.id == student.id
                    }) {
                    students.append(student)
                }
            }
        }
        
        return students
    }
    
    func getCharactersForRehearsal(_ rehearsal: Rehearsal) -> [Character] {
        guard let production = self.getProductionForRehearsal(rehearsal) else { return [] }
        let casting = production.cast
        
        let characters: [Character] = casting.filter({ casting in
            return rehearsal.characterIds.contains(casting.character.id)
        }).map({ casting in
            return casting.character
        }).removingDuplicates()
        
        return characters.sorted(by: {(a, b) in
            return a.name < b.name
        })
    }
    
    func getCastForRehearsal(_ rehearsal: Rehearsal) -> [Cast] {
        guard let production = self.getProductionForRehearsal(rehearsal) else { return [] }
        
        return production.cast.filter({cast in
            return rehearsal.characterIds.contains(cast.character.id)
        })
    }
    
    func getCastingsForStudent(_ student: Student, inProduction production: Production) -> [Cast] {
        return production.cast.filter({cast in
            return cast.student.id == student.id
        })
    }
    
    func getConflictForStudent(_ student: Student, atRehearsal rehearsal: Rehearsal) -> ConflictType? {
        let conflicts = rehearsal.conflicts
        return conflicts.first(where: { conflict in
            return student.id == conflict.studentId
        }).map{ conflict in
            return conflict.type
        }
    }
    
    func getAllConflictsForFamily() -> [Conflict] {
        var conflicts = [Conflict]()
        
        for production in productions {
            for rehearsal in production.rehearsals {
                if rehearsal.conflicts.count > 0 {
                    for conflict in rehearsal.conflicts {
                        if family.contains(where: { person in
                            return person.id == conflict.studentId
                        }) {
                            conflicts.append(conflict)
                        }
                    }
                }
            }
        }
        
        return conflicts
    }
    
    func getRehearsalWithId(_ id: Int) -> Rehearsal? {
        return productions.filter({ production in
            production.rehearsals.contains(where: { rehearsal in
                rehearsal.id == id
            })
        })[0].rehearsals.filter({ rehearsal in
            rehearsal.id == id
        })[0]
    }
    
    func getStudentsInProduction(_ production: Production) -> [Student] {
        var students = [Student]()
        
        for castDetail in production.cast {
            if !students.contains(where: { student in
                student.id == castDetail.student.id
            }) {
                students.append(castDetail.student)
            }
        }
        
        for person in family {
            if students.contains(where: { student in
                student.id == person.person.id
            }) {
                students.removeAll(where: { student in
                    student.id == person.person.id
                })
                
                students.append(person as! Student)
            }
        }
        
        return students.sorted(by: { (a, b) in
            if family.contains(where: { member in
                member.person.id == a.person.id
            }) == family.contains(where: { member in
                member.person.id == b.person.id
            }) {
                return a.person.fullName < b.person.fullName
            } else {
                return family.contains(where: { member in
                    member.person.id == a.person.id
                })
            }
        })
    }
    
    func getStudentWithId(_ id: Int, inProduction production: Production) -> Student? {
        return getStudentsInProduction(production).first(where: { student in
            student.id == id
        })
    }

    func getProductionTitleForRehearsal(_ rehearsal: Rehearsal) -> String? {
        return self.getProductionForRehearsal(rehearsal)?.title
    }
        
    func getRehearsalDateStringForRehearsal(_ rehearsal: Rehearsal) -> String {
        return rehearsal.start.toStringWithFormat("EEEE, MMMM d, yyyy")
    }
    
    func getRehearsalTimeStringForRehearsal(_ rehearsal: Rehearsal) -> String {
        return rehearsal.start.toStringWithFormat("h:mm a")
        + "-"
            + rehearsal.end.toStringWithFormat("h:mm a")
    }
}
