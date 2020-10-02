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
    
    @Published var user: User?
    @Published var adult: Adult?
    
    init() {
        self.user = User.default
        self.adult = Adult.default
    }
    
    //**********************************************************************
    // MARK: - USER FUNCTIONS
    //**********************************************************************
    
    /**
     Logs in a user based on their userToken and password combination.
     
     If the user is valid, sets isLoggedIn to true and sets the user variable with the appropriate information. Then, if the user is linked, the method will call the loadDataForUser method. Upon success, returns true.
     
     If the user is not valid, sets isLoggedIn to false, sets the current user error message, and returns false.
     */
    func verifyUser(_ userToken: String, withPassword pwd: String) -> Bool {
        // TODO: Implement this function.
        return true
    }
    
    /**
     If the two password parameters match, create a new user based on the userToken and password provided.
     
     If successful, set isLoggedIn to true, set the user variable with the appropriate information, and then call loadDataForUser. Return true.
     
     If not valid, set isLoggedIn to false, set the current user error message, and return false.
     */
    func createUser(_ userToken: String, withPassword pwd: String, andVerificationPassword pwd2: String) -> Bool {
        // TODO: Implement this function.
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
    func setPersonForUser(_ user: User) -> Bool {
        // TODO: Implement this function
        return true
    }
    
    /**
     Using the userId and the linking code, queries the API to link the user to a person and then sets the primary user for this session based off of the response data. If successful, returns true. Else, sets the current user error message and returns false.
     */
    func setPersonForUser(_ user: User, withLinkingCode code: String) -> Bool {
        // TODO: Implement this function
        return true
    }
    
    /**
     Updates the database with the given person information. Returns true on success. Else, sets the current user error message and returns false.
     */
    func updatePersonUsing(_ person: Person) -> Bool {
        // TODO: Implement this function
        return true
    }
}
