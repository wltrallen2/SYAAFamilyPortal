//
//  Constants.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/16/20.
//

import Foundation

struct Constants {
    
    struct Content {
        
        //**********************************************************************
        // MARK: - LOGIN PROCESSES
        //**********************************************************************
                
        // TODO: Turn all phone numbers and emails to clickable links. Here 🔽
        static let ForgotPwdInfoString = "Adult users can request a password reset by entering their email address on file for their account. Then, when you click the button, we will send you an email about how to reset your password.\n\nStudent users will need to contact the box office to request a password change.\n\nIf you need additional help, please contact our box office at (318) 812-7922."
        // TODO: Turn all phone numbers and emails to clickable links. And here 🔽
        static let SentPwdResetString = "An email has been sent with further instructions. If you continue to have problems, please feel free to reach out to us by phone at (318) 812-7922 or email at boxoffice@syaaonline.com."
        
        // Link Account View
        static let LinkAccountInstructionString = "Please enter the SYAA Link Code supplied to you by the box office to link this account to your SYAA parent/student profile."
                
        
        //**********************************************************************
        // MARK: - ERROR MESSAGES
        //**********************************************************************
        
        // Log In Error Messages
        // TODO: Turn all phone numbers and emails to clickable links. And here 🔽
        static let ServerAccessError = "There was an error accessing our database. If this problem continues, please contact us at (318) 812-7922 or boxoffice@syaaonline.com."
        static let UserDidNotEnterInfo = "The username and/or password fields are blank. Please enter a username and password to log in."
        // TODO: Turn all phone numbers and emails to clickable links. And here 🔽
        static let AppCodeError = "There seems to be an error in our application code. Please take a screenshot and send info to boxoffice@syaaonline.com"
        static let UserNotFound = "The username/password combination that you entered is not in our database. Please check your records and try again."
        
        // Create User Error Messages
        static let PasswordLengthError = "Passwords must be at least eight (8) characters in length. Please try again."
        static let PasswordMatchError = "Your passwords do not match. Please try again."
        static let UsernameLengthError = "Your username must be at least four characters in length."
        // TODO: Turn all phone numbers and emails to clickable links. And here 🔽
        static let UniqueUserError = "The username that you have chosen already appears in our database. Please choose a different name or contact us at (318) 812-7922 for additional help."
        
        // Link Account Error Message
        static let NoSuchLinkCodeError = "Error: We do not have the SYAA Link Code that you entered in our database. Please try again or contact our box office for more details."
    }
    
    struct API {
        static let Prefix_Local = "http://localhost:8888/api/"
        static let Prefix = "http://www.syaaonline.com/api/"
        
        static let CreateUser = "add/user"
        static let PwdReset = "requestPwdReset"
        static let LinkUser = "link/user"
        static let SelectUser = "select/user"
        static let VerifyUser = "verify/user"
        static let UpdateAdult = "update/adult"
        
        struct Params {
            static let Code = "code"
            static let Email = "email"
            static let Password = "password"
            static let PasswordToVerify = "password_verify"
            static let UserId = "userId"
            static let Username = "userToken"
            
            // For Adult
            static let PersonId = "personId"
            static let FirstName = "firstName"
            static let LastName = "lastName"
            static let Address1 = "address1"
            static let Address2 = "address2"
            static let City = "city"
            static let State = "state"
            static let Zip = "zip"
            static let Phone1 = "phone1"
            static let Phone1Type = "phone1Type"
            static let Phone2 = "phone2"
            static let Phone2Type = "phone2Type"
            static let email = "Email"
        }
    }

    
}
