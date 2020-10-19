//
//  HTTPOutputProcessor.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/21/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import Foundation

struct HTTPOutputProcessor {
    var output: URLSession.DataTaskPublisher.Output
    
    func decode<T>(toType type: T.Type) throws -> T where T : Decodable {
        guard let response = output.response as? HTTPURLResponse else {
            print("Output: \(output)")
            throw HTTPError.InternalServiceError }
        
        // FIXME: Remove or comment out debugging code.
//        print()
//        print("Response Code: \(response.statusCode)")
//        let responseString = String(bytes: output.data, encoding: .utf8)
//        print("Response String:\n\(responseString ?? "No Response")")
//        print()

        guard response.statusCode == 200 else {
            // FIXME: Insert new errors into HTTPError so that we get meaninful errors.
            let httpError = HTTPError.init(rawValue: response.statusCode) ?? HTTPError.InternalServiceError
            throw httpError }
        guard let obj = try? JSONDecoder().decode(type, from: output.data) else {
            throw HTTPError.InvalidJsonObjectType }
        return obj
    }
}
