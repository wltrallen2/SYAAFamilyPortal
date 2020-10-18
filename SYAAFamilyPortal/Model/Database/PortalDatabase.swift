//
//  PortalDatabase.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/2/20.
//

import Foundation
import Combine

enum AppError: LocalizedError {
    case Coding
}

protocol IdCodable: Codable {
    var id: Int { get }
}

// FIXME: Update website to use SSL and remove the exception to the NSAppTransportSecurity in the Info.plist
class PortalDatabase {
    var api: API
    private var cancellable: AnyCancellable?
    
    init() {
        guard let path = Bundle.main.path(forResource: "Secure", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let api = try? PropertyListDecoder().decode(API.self, from: xml) else {
            fatalError("Unable to decode API details from Secure property list.")
        }
        
        self.api = api
    }

    func executeAPICall<SendingType: Encodable, ReceivingType: Decodable>(onPath path: String, withEncodable dataObj: SendingType, withTypeToReceive type: ReceivingType.Type, onFail failCallback:@escaping (LocalizedError, String) -> Void, andOnSuccess callback:@escaping (ReceivingType) -> Void) {
        
        guard let request = createRequest(onApiPath: path,
                                          usingData: dataObj) else {
            failCallback(AppError.Coding,
                         "Error creating request at PortalDatabase, line 35")
            return
        }
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ output -> ReceivingType in
                let processor = HTTPOutputProcessor(output: output)
                return try processor.decode(toType: type)
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let httpError as HTTPError):
                    failCallback(httpError, self.getErrorMessage(forAPICall: path, andError: httpError))
                    break
                case .failure(let error):
                    failCallback(AppError.Coding, "Error in PortalDatabase, line 58: \(error.localizedDescription)")
                }
            }, receiveValue: { object in
                callback(object)
            })
    }
    
    //**********************************************************************
    // MARK: - CREATE REQUEST METHODS
    //**********************************************************************
    
    // Accepts a dictionary of String objects mapped to optional Any objects
    public func createRequest(onApiPath path: String, usingData data: Dictionary<String, Any?>) -> URLRequest? {
        guard let requestBody = try? JSONSerialization.data(withJSONObject: data) else {
            print("Failed to encode json with given data in APICall object")
            return nil }
        return createRequest(onApiPath: path, withRequestBody: requestBody)
    }

    // Accepts a dictionary of String objects mapped to Any objects
    public func createRequest(onApiPath path: String, usingData data: Dictionary<String, Any>) -> URLRequest? {
        guard let requestBody = try? JSONSerialization.data(withJSONObject: data) else {
            print("Failed to encode json with given data in APICall object")
            return nil }
        return createRequest(onApiPath: path, withRequestBody: requestBody)
    }
    
    // Accepts an object that conforms to the Encodable protocol
    public func createRequest<T: Encodable>(onApiPath path: String, usingData data: T) -> URLRequest? {
        guard let requestBody = try? JSONEncoder().encode(data) else {
            print("Failed to encode json with given data in APICall object")
            return nil }
        return createRequest(onApiPath: path, withRequestBody: requestBody)
    }
    
    //**********************************************************************
    // MARK: - PRIVATE HELPER METHODS
    //**********************************************************************
    
    // Returns an optional URLRequest object based on an api path (String) and a Data object to send.
    private func createRequest(onApiPath path: String, withRequestBody data: Data) -> URLRequest? {
        guard let url = getApiUrl(forPath: path) else {
            print("Failed to initialize url from path: \(path)")
            return nil }
        return createRequest(withURL: url, withRequestBody: data)
    }

    // Returns an optional URL object based on the String path passed in
    private func getApiUrl(forPath path: String) -> URL? {
        let urlString = Constants.API.Prefix + path
        return URL(string: urlString)
    }
    
    // Returns a URLRequest based on the URL and Data objects passed into the fuction.
    private func createRequest(withURL url: URL, withRequestBody data: Data) -> URLRequest {
        let apiKey = api.key;

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY");
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
    }

    
    //**********************************************************************
    // MARK: - Data Functions for Local Test Data
    //**********************************************************************
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


    //**********************************************************************
    // MARK: - PRIVATE HELPER FUNCTION - HTTP ERRORS
    //**********************************************************************
    
    // FIXME: Retool this to have appropriate error messages and switches
    private func getErrorMessage(forAPICall apiCall: String, andError error: HTTPError) -> String {
        switch apiCall {
        case api.path(.VerifyUser):
            switch error {
            case .NotFound:
                return Constants.Content.UserNotFound
            default:
                return Constants.Content.ServerAccessError
            }
        case api.path(.CreateUser):
            switch error {
            case .UsernameLength:
                return Constants.Content.UsernameLengthError
            case .PasswordLength:
                return Constants.Content.PasswordLengthError
            case .PasswordMatch:
                return Constants.Content.PasswordMatchError
            case .Conflict:
                return Constants.Content.UniqueUserError
            default:
                return Constants.Content.ServerAccessError
            }
        default:
            return Constants.Content.ServerAccessError
        }
    }

}
