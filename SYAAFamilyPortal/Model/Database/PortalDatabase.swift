//
//  PortalDatabase.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/2/20.
//

import Foundation

protocol IdCodable: Codable {
    var id: Int { get }
}

class PortalDatabase {

    func executeAPICall<SendingType: Encodable, ReceivingType: Decodable>(onPath path: String, withEncodable dataObj: SendingType, andOnSuccess callback: (ReceivingType) -> Void) {
        // TODO: Implement this function to execute API calls
    }
    
    // Loads Decodable data from a local file.
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        let file = getURLForBundleFileWithName(filename)
        
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
    
    // Saves json Data to a local file
    func save<T: Encodable>(encodableObject obj: T, toFileWithName filename: String) {
        let file = getURLForBundleFileWithName(filename)
        
        do {
            let jsonData = try JSONEncoder().encode(obj)
            try jsonData.write(to: file)
        } catch let error {
            print("Unable to write data to file: \(error)")
        }
    }
    
    // Inserts a record into a local file, replacing any record with the same id if it exists
    func insert<T: IdCodable>(codableObject obj: T, intoArray array: [T], usingFileWithName filename: String) {
        var objects: [T] = self.load(filename)
        
        objects.removeAll(where: { o -> Bool in
            return obj.id == o.id
        })
        
        objects.append(obj)
        self.save(encodableObject: objects, toFileWithName: filename)
    }
    
    private func getURLForBundleFileWithName(_ filename: String) -> URL {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
                
        return file
    }
}
