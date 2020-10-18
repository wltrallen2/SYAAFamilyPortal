//
//  HTTPStatus.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/7/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import Foundation

enum HTTPError: Int, LocalizedError {
    case BadRequest = 400
    case Unauthorized = 401
    case NotFound = 404
    case MethodNotAllowed = 405
    case Conflict = 409
    case UsernameLength = 460
    case PasswordLength = 461
    case PasswordMatch = 462
    case InvalidLinkingCode = 469
    case InternalServiceError = 500
    case InvalidJsonObjectType = 501
    
    var description: String {
        switch self {
        case .BadRequest:
            return "BadRequest"
        case .Unauthorized:
            return "Unauthorized"
        case .NotFound:
            return "NotFound"
        case .MethodNotAllowed:
            return "MethodNotAllowed"
        case .Conflict:
            return "Conflict"
        case .UsernameLength:
            return "UsernameLength"
        case .PasswordLength:
            return "PasswordLength"
        case .PasswordMatch:
            return "PasswordMatch"
        case .InvalidLinkingCode:
            return "InvalidLinkingCode"
        case .InternalServiceError:
            return "InternalServiceError"
        case .InvalidJsonObjectType:
            return "InvalidJsonObjectType"
        }
    }
}
