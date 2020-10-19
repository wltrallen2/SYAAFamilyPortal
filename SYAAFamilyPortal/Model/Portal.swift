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
            if self.adult != nil && self.family.count == 0 {
                self.fetchFamily()
            }
        }
    }
    @Published var student: Student? {
        didSet {
            if self.student != nil {
                self.setFamilyConflicts()
            }
        }
    }
    
    @Published var family: [Personable] = [] {
        didSet {
            if family.count > 0 {
                self.setFamilyConflicts()
                
            }
        }
    }
    @Published var familyConflicts: [Conflict] = []

    
    @Published var productions: [Production] = [] {
        didSet {
            self.setOtherStudents()
        }
    }
    @Published var otherStudents: [Student] = []
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
    func verifyUser(_ userToken: String, withPassword pwd: String) {

        let dataDict = [
            "userToken": userToken,
            "password": pwd
        ]
        
        db.executeAPICall(onPath: db.api.path(.VerifyUser),
                          withEncodable: dataDict,
                          withTypeToReceive: User.self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .VerifyUser) },
                          andOnSuccess: { (user : User) in
                            self.user = user
                            self.isLoggedIn = true
                            
                            if(self.user!.isLinked) {
                                self.selectPersonForUser(self.user!)
                            }
                          })
    }
    
    /**
     If the two password parameters match, create a new user based on the userToken and password provided.
     
     If successful, set isLoggedIn to true, set the user variable with the appropriate information, and return true. NOTE: The user will never be linked if their account has just been created. Therefore, no call to load person data is made from this function.
     
     If not valid, set isLoggedIn to false, set the current user error message, and return false.
     */
    func createUser(_ userToken: String, withPassword pwd: String, andVerificationPassword pwd2: String) {
        if pwd != pwd2 {
            error = "The passwords you entered did not match. Please try again."
            return
        } else if userToken.count < 8 {
            error = "Please choose a username that has at least eight (8) characters."
            return
        }
        
        let dataDict = [
            "userToken": userToken,
            "password": pwd,
            "password_verify": pwd2
        ]
        
        db.executeAPICall(onPath: db.api.path(.CreateUser),
                          withEncodable: dataDict,
                          withTypeToReceive: User.self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .CreateUser) },
                          andOnSuccess: { (user: User) in
                            self.user = user
                            self.isLoggedIn = true
                            
                            if(self.user!.isLinked) {
                                self.selectPersonForUser(self.user!)
                            }
                          })
    }
    
    /**
     Through the API, handle the password reset request and return true. Return false if the request fails.
     
     NOTE: The API currently only resets the password for adult users since only adult users are required to have email addresses on file. For the future, implement an option that accepts a userToken instead. This will also allow for users to have more than one userToken tied to their account.
     */
    // FIXME: Implement a version of this function that allows users to reset their password using their userToken, not their email. This will allow for students to reset their password as well.
    func requestPwdReset(forUserWithEmail email: String, onCompletion completion:@escaping (Bool) -> Void) {
        if !email.isValidEmail() {
            error = "Please enter a valid email address."
            return
        }
        
        db.executeAPICall(onPath: db.api.path(.PasswordReset),
                          withEncodable: ["email":email],
                          withTypeToReceive: [String:Bool].self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .PasswordReset) },
                          andOnSuccess: { (outcome: [String:Bool]) in
                            completion(outcome["success"] ?? false)
                          })
    }
    
    //**********************************************************************
    // MARK: - PERSON FUNCTIONS
    //**********************************************************************
    
    /**
     Using the userId, queries the API to select the user information and sets the primary user for this session. If successful, returns true. If unsuccessful, sets the current user error message and returns false.
     */
    func selectPersonForUser(_ user: User) {
        guard self.user != nil else {
            fatalError("No user logged in.")
        }
        
        if !self.user!.isLinked {
            self.error = "User has not been linked to person accoutn yet"
            return
        }
        
        db.executeAPICall(onPath: db.api.path(.SelectUser),
                          withEncodable: ["userId":self.user!.id],
                          withTypeToReceive: Adult.self,
                          onFail: { (error, errorMsg) in
                            self.receiveError(error, "SelectUser API Call - No Adult Found: \(error)", forAPIRequest: .SelectUser)
                            self.db.executeAPICall(onPath: self.db.api.path(.SelectUser),
                                              withEncodable: ["userId":self.user!.id],
                                              withTypeToReceive: Student.self,
                                              onFail: { (error, errorMsg) in
                                                self.receiveError(error, "SelectUser API Call - No Student Found: \(error)", forAPIRequest: .SelectUser)
                                              },
                                              andOnSuccess: { (student: Student) in
                                                self.student = student
                                              })
                          }, andOnSuccess: { (adult: Adult) in
                            self.adult = adult
                          })
    }
    
    /**
     Using the userId and the linking code, queries the API to link the user to a person and then sets the primary user for this session based off of the response data. If successful, returns true. Else, sets the current user error message and returns false.
     */
    func selectPerson(usingLinkingCode code: String) {
        guard self.user != nil else {
            fatalError("No user logged in.")
        }
        
        struct CodePair: Codable {
            var userId: Int
            var code: String
        }
        
        let codePair = CodePair(userId: user!.id, code: code)
        
        db.executeAPICall(onPath: db.api.path(.LinkUser),
                          withEncodable: codePair,
                          withTypeToReceive: Adult.self,
                          onFail: { (error, errorMsg) in
                            self.receiveError(error, "SelectUser API Call - No Adult Found: \(error)", forAPIRequest: .LinkUser)
                            if error as? HTTPError == HTTPError.InvalidJsonObjectType {
                                self.db.executeAPICall(
                                    onPath: self.db.api.path(.SelectUser),
                                    withEncodable: ["userId": self.user!.id],
                                    withTypeToReceive: Student.self,
                                    onFail: { (error, errorMsg) in
                                        self.receiveError(error, "SelectUser API Call - No Student Found: \(error)", forAPIRequest: .SelectUser)
                                    },
                                    andOnSuccess: { student in
                                        self.user?.isLinked = true
                                        self.student = student
                                    })
                            } else {
                                self.db.executeAPICall(onPath: self.db.api.path(.LinkUser),
                                                  withEncodable: codePair,
                                                  withTypeToReceive: Student.self,
                                                  onFail: { (error, errorMsg) in
                                                    self.receiveError(error, "SelectUser API Call - No Stuent Found: \(error)", forAPIRequest: .LinkUser)
                                                  },
                                                  andOnSuccess: { (student: Student) in
                                                    self.user?.isLinked = true
                                                    self.student = student
                                                  })
                            }
                          }, andOnSuccess: { (adult: Adult) in
                            self.user?.isLinked = true
                            self.adult = adult
                          })
    }
    
    /**
     Updates the database with the given person information. Returns true on success. Else, sets the current user error message and returns false.
     */
    func updatePersonUsing(_ person: Personable) {
        if person is Adult {
            let adult = person as! Adult
            db.executeAPICall(onPath: db.api.path(.UpdateAdult),
                              withEncodable: adult,
                              withTypeToReceive: Adult.self,
                              onFail: { self.receiveError($0, $1, forAPIRequest: .UpdateAdult) },
                              andOnSuccess: { self.updateLocalPeople(withPerson: $0) })
        } else if person is Student {
            let student = person as! Student
            db.executeAPICall(onPath: db.api.path(.UpdateStudent),
                              withEncodable: student,
                              withTypeToReceive: Student.self,
                              onFail: { self.receiveError($0, $1, forAPIRequest: .UpdateStudent)},
                              andOnSuccess: { self.updateLocalPeople(withPerson: $0) })
        }
    }
       
    func fetchFamily() {
        guard let adultId = self.adult?.person.id else { return }
        self.family.removeAll()
        
        struct FamilyDataDict: Encodable {
            var personId: Int
            var typeLimit: String
        }
        
        let adultDataDict = FamilyDataDict(personId: self.adult!.person.id,
                                           typeLimit: "Adult")
        
        let studentDataDict = FamilyDataDict(personId: self.adult!.person.id,
                                             typeLimit: "Student")
        
        db.executeAPICall(onPath: db.api.path(.SelectFamily),
                          withEncodable: adultDataDict,
                          withTypeToReceive: Array<Adult>.self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .SelectFamily)},
                          andOnSuccess: { (adults: [Adult]) in
                            self.family.append(
                                contentsOf: adults.filter(
                                    { $0.person.id != adultId}))
                            self.family.sort(by: { $0.person.fullName < $1.person.fullName })
                            
                            self.db.executeAPICall(onPath: self.db.api.path(.SelectFamily),
                                              withEncodable: studentDataDict,
                                              withTypeToReceive: Array<Student>.self,
                                              onFail: { self.receiveError($0, $1, forAPIRequest: .SelectFamily)},
                                              andOnSuccess: { (students: [Student]) in
                                                self.family.append(contentsOf: students)
                                                self.family.sort(by: { $0.person.fullName < $1.person.fullName })
                                              })
                          })
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
        // There is no data needed for this API call, so I pass in an empty array to utilize existing executeAPICall method, which requires some sort of dictionary to encode. Empty data will simply be ignored by API.
        let emptyDict = [String: String]()
        
        db.executeAPICall(onPath: db.api.path(.SelectUpcomingProductions),
                          withEncodable: emptyDict,
                          withTypeToReceive: [Production].self,
                          onFail: { error, errorMsg in
                            print("failed")
                            self.receiveError(error, errorMsg, forAPIRequest: .SelectUpcomingProductions)},
                          andOnSuccess: { (productions: [Production]) in
                            print("success")
                            self.productions.removeAll()
                            self.productions.append(contentsOf: productions)
                            self.productions.sort(by: { $0.start < $1.start })
                          })
    }
        
    func setOtherStudents() {
        // There is no data needed for this API call, so I pass in an empty array to utilize existing executeAPICall method, which requires some sort of dictionary to encode. Empty data will simply be ignored by API.
        let emptyDict = [String:String]()
        
        db.executeAPICall(onPath: db.api.path(.SelectAllStudents)
                          , withEncodable: emptyDict,
                          withTypeToReceive: [Student].self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .SelectAllStudents)},
                          andOnSuccess: { self.setOtherStudentsUsing($0) }
        )
    }
    
    func setFamilyConflicts() {
        struct SelectConflictsData: Encodable {
            var studentIds: [Int]
            var startDate: String
        }
        
        var studentIds = [Int]()
        if self.student != nil {
            studentIds.append(self.student!.person.id)
        } else {
            studentIds.append(contentsOf: family.compactMap({ $0 as? Student}).compactMap({ $0.person.id }))
        }
        
        var date = Date()
        if let startDate = productions.compactMap({ $0.start }).sorted().first {
            date = startDate
        }
        
        // FIXME: Remove this test code.
        date = Calendar.current.date(byAdding: .year, value: -3, to: Date())!
        
        let selectConflictsData = SelectConflictsData(studentIds: studentIds, startDate: date.toStringWithFormat("y-M-d"))
        
        db.executeAPICall(onPath: db.api.path(.SelectUpcomingConflicts),
                          withEncodable: selectConflictsData,
                          withTypeToReceive: [Conflict].self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .SelectUpcomingConflicts)},
                          andOnSuccess: { self.setAndSortFamilyConflicts($0) })
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
        db.executeAPICall(onPath: db.api.path(.DeleteConflict),
                          withEncodable: conflict,
                          withTypeToReceive: [String:Bool].self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .DeleteConflict)},
                          andOnSuccess: { (success: [String: Bool]) in
                            if(success["success"] == true) {
                                self.familyConflicts.removeAll(where: { $0.id == conflict.id })
                                self.sortFamilyConflict()
                            }
                          })
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
            let student = students.first!
            let conflict = Conflict(id: id,
                                    rehearsalId: elements.rehearsal.id,
                                    studentId: student.person.id,
                                    type: elements.type)
            
            self.addConflict(conflict)
            students.removeFirst()
        }
    }
    
    func addConflict(_ conflict: Conflict) {
        db.executeAPICall(onPath: db.api.path(.InsertConflict),
                          withEncodable: conflict,
                          withTypeToReceive: [String:Bool].self,
                          onFail: { self.receiveError($0, $1, forAPIRequest: .InsertConflict)},
                          andOnSuccess: { (success: [String: Bool]) in
                            if(success["success"] == true) {
                                self.familyConflicts.append(conflict)
                                self.sortFamilyConflict()
                            }
                          })
    }
    
    func updateConflicts(withDetails elements: ConflictTabElement) {
        var students = elements.students
        for id in elements.ids {
            self.removeConflictsWithIds([id])
            if let student = students.first {
                let newConflict = Conflict(id: id,
                                           rehearsalId: elements.rehearsal.id,
                                           studentId: student.person.id,
                                           type: elements.type)
                self.addConflict(newConflict)
                students.removeFirst()
            }
        }
        
        for student in students {
            let intString = "\(elements.rehearsal.id)\(student.person.id)"
            let newConflict = Conflict(id: Int(intString) ?? 0,
                                       rehearsalId: elements.rehearsal.id,
                                       studentId: student.person.id,
                                       type: elements.type)
            self.addConflict(newConflict)
        }
    }
    
    //**********************************************************************
    // MARK: - PRIVATE HELPER FUNCTIONS
    //**********************************************************************
    
    private func receiveError(_ error: LocalizedError, _ errorMsg: String, forAPIRequest apiRequest: APIPath) {
        print("Error executing \(apiRequest.rawValue) API Request: \(error)")
        self.error = errorMsg
    }
    
    private func getStudentIdsForUser() -> [Int] {
        if self.student != nil { return [ self.student!.person.id ]}
        else {
            return family.compactMap( { $0 as? Student } ).map({ student in
                return student.person.id
            })
        }
    }
    
    private func setAndSortFamilyConflicts(_ conflicts: [Conflict]) {
        familyConflicts.removeAll()
        familyConflicts.append(contentsOf: conflicts)
        
        sortFamilyConflict()
    }
    
    private func sortFamilyConflict() {
        familyConflicts.sort(by: { (a, b) in
            if getRehearsalWithId(a.rehearsalId)!.start == getRehearsalWithId(b.rehearsalId)!.start {
                return getStudentWithId(a.studentId)!.person.fullName < getStudentWithId(b.studentId)!.person.fullName
            } else {
                return getRehearsalWithId(a.rehearsalId)!.start < getRehearsalWithId(b.rehearsalId)!.start
            }
        })
    }
    
    private func setOtherStudentsUsing(_ students: [Student]) {
        otherStudents.append(contentsOf: students.filter( { student in
            !family.contains(where: { person in
                person.person.id == student.person.id
            })
        }))
        
        otherStudents.sort(by: { $0.person.fullName < $1.person.fullName } )
    }
    
    private func updateLocalPeople(withPerson person: Personable) {
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
    }
}

enum ConflictError: Error {
    case AlreadyExists
}
