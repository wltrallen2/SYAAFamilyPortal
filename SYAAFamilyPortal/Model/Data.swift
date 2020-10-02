//
//  Data.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/30/20.
//

import Foundation

let adultData: [Adult] = load("adultData.json")
let statesData: [String: String] = load("states.json")
let statesDict = statesData.sorted { s1, s2 in
    s1.value < s2.value
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
