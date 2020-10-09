//
//  DateExtension.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import Foundation

extension Date {
    func slashStyle() -> String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/YYYY"
        return df.string(from: self)
    }
}

extension String {
    func toDateFromFormat(_ format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        
        return df.date(from: self) ?? nil
    }
}