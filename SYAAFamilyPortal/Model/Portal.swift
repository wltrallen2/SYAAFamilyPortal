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
    
    @Published var family: [Personable] = [Student.default, Student.default, Student.default, Adult.default, Adult.default]
    
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
            print("UpdatePerson \(person.person.firstName) has verified? \(person.person.hasVerified)")
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
}
