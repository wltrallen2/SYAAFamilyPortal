//
//  DateExtension.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import Foundation

extension Date {
    func toStringWithFormat(_ format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
    
    func slashStyle() -> String {
        return self.toStringWithFormat("MM/dd/yyyy")
    }
    
    func dashStyle() -> String {
        return self.toStringWithFormat("yyyy-MM-dd")
    }
    
    func year() -> String {
        return self.toStringWithFormat("yyyy")
    }
}

extension String {
    func toDateFromFormat(_ format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        
        return df.date(from: self) ?? nil
    }
}
