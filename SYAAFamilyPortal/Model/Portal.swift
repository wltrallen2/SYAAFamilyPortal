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
    @Published var student: Student? {
        didSet {
            self.setFamilyConflicts()
        }
    }
    
    @Published var family: [Personable] = [
                                    Student.default, Student.default,
                                    Adult.default,
                                    Adult.default
                                ] {
        didSet {
            self.setFamilyConflicts()
        }
    }
    @Published var familyConflicts: [Conflict] = []

    
    @Published var productions: [Production] = [Production.default] {
        didSet {
            self.setOtherStudents()
        }
    }
    @Published var otherStudents: [Student] = load("studentData.json") // NEXT: Remove all default values from testing
            
    //**********************************************************************
    // MARK: - USER FUNCTIONS
    //**********************************************************************
    
    func logout() {
        self.user = nil
        self.adult = nil
        self.student = nil
        self.family.removeAll()
        self.familyConflicts.removeAll()
        self.productions.removeAll()
        self.otherStudents.removeAll()
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
    // MARK: - PRODUCTION FUNCTIONS: Setters
    //**********************************************************************
    
    func setProductions() {
        // FIXME: Temporary Implementation
        productions = db.load("productionData.json");
    }
        
    func setOtherStudents() {
        // FIXME: Temporary Implementation
        let students: [Student] = db.load("studentData.json");
        
        otherStudents.append(contentsOf: students.filter( { student in
            !family.contains(where: { person in
                person.person.id == student.person.id
            })
        }))
    }
    
    func setFamilyConflicts() {
        // FIXME: Temporary Implementation
        let conflicts: [Conflict] = db.load("conflictData.json")
        
        let students = self.student != nil ? [ self.student ] : family.compactMap( { $0 as? Student })
        
        familyConflicts.removeAll()
        familyConflicts.append(contentsOf: conflicts.filter({ conflict in
            students.contains(where: { student in
                student?.person.id == conflict.studentId
            })
        }))
        
        familyConflicts.sort(by: { (a, b) in
            if getRehearsalWithId(a.rehearsalId)!.start == getRehearsalWithId(b.rehearsalId)!.start {
                return getStudentWithId(a.studentId)!.person.fullName < getStudentWithId(b.studentId)!.person.fullName
            } else {
                return getRehearsalWithId(a.rehearsalId)!.start < getRehearsalWithId(b.rehearsalId)!.start
            }
        })
    }
    
    func getMyStudents() -> [Student] {
        var students = [Student]()
        
        if self.student != nil {
            students.append(self.student!)
        } else {
            students.append(contentsOf: self.family.compactMap({ $0 as? Student }))
        }

        return students.sorted(by: { (a, b) in a.person.fullName < b.person.fullName })
    }
    
    //**********************************************************************
    // MARK: - PRODUCTION FUNCTIONS: Get by Rehearsal
    //**********************************************************************
    
    func getProductionForRehearsal(_ rehearsal: Rehearsal) -> Production? {
        let pid = rehearsal.productionId
        return self.productions.first(where: { production in
            return production.id == pid
        }) ?? nil
    }
    
    // MARK: Get Characters
    func getCharactersForRehearsal(_ rehearsal: Rehearsal) -> [Character] {
        // Get a list of studentIds for all students cast in this production
        guard let production = getProductionForRehearsal(rehearsal) else { return [] }
        return production.characters.filter({ character in
            rehearsal.characterIds.contains(character.id)
        })
    }
    
    func getMyCharactersForRehearsal(_ rehearsal: Rehearsal) -> [Character] {
        guard let production = getProductionForRehearsal(rehearsal) else { return [] }
        return production.characters.filter({ character in
            getMyCastForRehearsal(rehearsal).map({ link in return link.characterId}).contains(character.id)
        }).sorted(by: { (a, b) in a.name < b.name })
    }
    
    func getOtherCharactersForRehearsal(_ rehearsal: Rehearsal) -> [Character] {
        guard let production = getProductionForRehearsal(rehearsal) else { return [] }
        return production.characters.filter({ character in
            getOtherCastForRehearsal(rehearsal).map({ link in return link.characterId}).contains(character.id)
        }).sorted(by: { (a, b) in a.name < b.name })
    }
    
    // MARK: Get Cast
    func getMyCastForRehearsal(_ rehearsal: Rehearsal) -> [CastingLink] {
        guard let production = getProductionForRehearsal(rehearsal) else { return [] }
        
        return production.castingLinks.filter({ link in
            getStudentIdsForUser().contains(link.studentId)
                && rehearsal.characterIds.contains(link.characterId)
        })
    }
    
    func getOtherCastForRehearsal(_ rehearsal: Rehearsal) -> [CastingLink] {
        guard let production = getProductionForRehearsal(rehearsal) else { return [] }
        
        return production.castingLinks.filter({ link in
            otherStudents.map({ student in return student.person.id }).contains(link.studentId)
                && rehearsal.characterIds.contains(link.characterId)
        })
    }
    
    // MARK: Get Students
    func getStudentsForRehearsal(_ rehearsal: Rehearsal) -> [Student] {
        var students = [Student]()
        students.append(contentsOf: getMyStudentsForRehearsal(rehearsal))
        students.append(contentsOf: getOtherStudentsForRehearsal(rehearsal))
        return students
    }
    
    func getMyStudentsForRehearsal(_ rehearsal: Rehearsal) -> [Student] {
        let myLinks = getMyCastForRehearsal(rehearsal)
        
        var students = [Student]()
        if self.student != nil {
            if myLinks.contains(where: { link in link.studentId == self.student!.person.id }) {
                students.append(self.student!)
            } else { return [] }
        } else {
            students.append(contentsOf: family.compactMap( {$0 as? Student} ).filter({ student in
                myLinks.contains(where: { link in link.studentId == student.person.id })
            }).sorted(by: { (a, b) in
                a.person.fullName < b.person.fullName
            }))
        }
        
        return students
    }
    
    func getOtherStudentsForRehearsal(_ rehearsal: Rehearsal) -> [Student] {
        let otherLinks = getOtherCastForRehearsal(rehearsal)
        
        return otherStudents.filter({ student in
            otherLinks.contains(where: { link in link.studentId == student.person.id})
        }).sorted(by: { (a, b) in
            a.person.fullName < b.person.fullName
        })
    }
    
    // MARK: Get Conflicts for Student
    func getConflictForStudent(_ student: Student, atRehearsal rehearsal: Rehearsal) -> ConflictType? {
        return familyConflicts.first(where: { conflict in
            rehearsal.id == conflict.rehearsalId
                && student.person.id == conflict.studentId
        }).map({ conflict in
            return conflict.type
        })
    }
    
    //**********************************************************************
    // MARK: - PRODUCTION FUNCTIONS: Get by ID
    //**********************************************************************
    func getRehearsalWithId(_ id: Int) -> Rehearsal? {
        return productions.flatMap({ production in
            production.rehearsals
        }).first(where: { rehearsal in
            rehearsal.id == id
        })
    }
    
    func getCharacterWithId(_ id: Int) -> Character? {
        return productions.flatMap({ production in
            production.characters
        }).first(where: { character in
            character.id == id
        })
    }
    
    func getStudentWithId(_ id: Int) -> Student? {
        if self.student?.person.id == id { return self.student! }
        
        if family.compactMap({ $0.person.id }).contains(id) {
            return family.first(where: { $0.person.id == id }) as? Student
        }
        
        return otherStudents.first(where: { $0.person.id == id })
    }
    
    //**********************************************************************
    // MARK: - PRODUCTION FUNCTIONS: Other
    //**********************************************************************
    
    func getAllCharacterIdsForStudent(_ student: Student) -> [Int] {
        return productions.compactMap({ $0.castingLinks }).flatMap({ $0 })
            .filter({ link in
                link.studentId == student.person.id
            }).compactMap({ $0.characterId})
    }
    
    func getAllCharactersForStudent(_ student: Student) -> [Character] {
        return getAllCharacterIdsForStudent(student).compactMap({ self.getCharacterWithId($0) })
    }

    func getCharacterIdsForStudent(_ student: Student, inProduction production: Production) -> [Int] {
        return production.castingLinks.filter({ link in
            link.studentId == student.person.id
        }).compactMap({ $0.characterId })
    }
    
    func getCharactersForStudent(_ student: Student, inProduction production: Production) -> [Character] {
        return getCharacterIdsForStudent(student, inProduction: production)
            .compactMap({ self.getCharacterWithId($0) })
    }
    
    
    //**********************************************************************
    // MARK: - PRODUCTION FUNCTIONS: String Conversions
    //**********************************************************************
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
    
    //**********************************************************************
    // MARK: - CONFLICT FUNCTIONS
    //**********************************************************************
    func removeConflict(_ conflict: Conflict) {
        familyConflicts.removeAll(where: { c in
            c.id == conflict.id
        })
        
        saveConflictsToDb()
    }
    
    func removeConflictsWithIds(_ ids: [Int]) {
        for id in ids {
            guard let conflict = familyConflicts.first(where: { c in c.id == id }) else { break }
            removeConflict(conflict)
        }
    }
    
    func addConflicts(withDetails elements: ConflictTabElement) {
        var students = [Student]()
        students.append(contentsOf: elements.students)
        
        for id in elements.ids {
            // FIXME: Test to make sure a conflict for this student on this date doesn't already exist.
//            if familyConflicts.contains(where: { c in
//                c.id == id
//            }) {
//                throw ConflictError.AlreadyExists
//            }
            
            let student = students.first!
            let conflict = Conflict(id: id,
                                    rehearsalId: elements.rehearsal.id,
                                    studentId: student.person.id,
                                    type: elements.type)
            familyConflicts.append(conflict)
            
            students.removeFirst()
        }
        
        saveConflictsToDb()
    }
    
    func updateConflicts(withDetails elements: ConflictTabElement) {
        var students = elements.students
        for id in elements.ids {
            familyConflicts.removeAll(where: { conflict in conflict.id == id })
            if let student = students.first {
                let newConflict = Conflict(id: id,
                                           rehearsalId: elements.rehearsal.id,
                                           studentId: student.person.id,
                                           type: elements.type)
                familyConflicts.append(newConflict)
                
                students.removeFirst()
            }
        }
        
        for student in students {
            let intString = "\(elements.rehearsal.id)\(student.person.id)"
            let newConflict = Conflict(id: Int(intString) ?? 0,
                                       rehearsalId: elements.rehearsal.id,
                                       studentId: student.person.id,
                                       type: elements.type)
            
            familyConflicts.append(newConflict)
        }
        
        saveConflictsToDb()
    }
    
    func saveConflictsToDb() {
        // Load original data from database
        var conflicts: [Conflict] = db.load("conflictData.json")
        
        // Remove all family conflicts from original data
        conflicts.removeAll(where: { conflict in
            self.student?.person.id == conflict.studentId
                || family.compactMap({ $0 as? Student }).contains(where: { student in
                    student.person.id == conflict.studentId
                })
        })
        
        // Add in new list of family conflicts
        conflicts.append(contentsOf: familyConflicts)
        
        // Encode and save
        db.save(encodableObject: familyConflicts, toFileWithName: "conflictData.json")
        
        setFamilyConflicts()
    }
    
    
    //**********************************************************************
    // MARK: - PRIVATE HELPER FUNCTIONS
    //**********************************************************************
    
    private func getStudentIdsForUser() -> [Int] {
        if self.student != nil { return [ self.student!.person.id ]}
        else {
            return family.compactMap( { $0 as? Student } ).map({ student in
                return student.person.id
            })
        }
    }
}

enum ConflictError: Error {
    case AlreadyExists
}
