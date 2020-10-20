//
//  SYAAFamilyPortalTests.swift
//  SYAAFamilyPortalTests
//
//  Created by Walter Allen on 9/30/20.
//

import XCTest
@testable import SYAAFamilyPortal
import Foundation

class SYAAFamilyPortalTests: XCTestCase {
    let portal = Portal()
    let db = PortalDatabase()
    
    let expectedFirstName = "Walter"
    let expectedLastName = "May-Allen"
    let expectedAddress1 = "310 Hilbert Drive"
    let expectedAddress2 = ""
    let expectedCity = "West Monroe"
    let expectedState = "LA"
    let expectedZip = "71291"
    let expectedPhone1 = "6192047586"
    let expectedPhone1Type = PhoneType.Cell
    let expectedPhone2 = "3188127922"
    let expectedPhone2Type = PhoneType.Work
    let expectedEmail = "wltrallen2@gmail.com"
    
    override func setUpWithError() throws {
        let expectation = XCTestExpectation()
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            self.portal.verifyUser("wltrallen2", withPassword: "kiwi4you")

            while(!self.portal.isLoggedIn) {
                sleep(1)
            }
            
            while(self.portal.adult == nil) {
                sleep(1)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 45.0)
    }

    
    func testUserLogin() throws {
        XCTAssertNotNil(self.portal.user, "User is nil.")
        XCTAssertEqual(self.portal.user?.userToken, "wltrallen2", "UserTokens do not match.")
        XCTAssertTrue(self.portal.user?.isLinked != nil, "User is not linked.")
    }
    
    func testAdultUserData() throws {
        XCTAssertNotNil(portal.adult, "Adult is nil.")
        XCTAssertEqual(portal.adult?.person.firstName, expectedFirstName,
                  "firstName values do not match.")
        XCTAssertEqual(portal.adult?.person.lastName, expectedLastName, "lastName values do not match.")
        XCTAssertEqual(portal.adult?.address1, expectedAddress1, "address1 values do not match.")
        XCTAssertEqual(portal.adult?.address2, expectedAddress2, "address2 values do not match.")
        XCTAssertEqual(portal.adult?.city, expectedCity, "city values do not match.")
        XCTAssertEqual(portal.adult?.state, expectedState, "state values do not match.")
        XCTAssertEqual(portal.adult?.zip, expectedZip, "zip values do not match.")
        XCTAssertEqual(portal.adult?.phone1, expectedPhone1, "phone1 values do not match.")
        XCTAssertEqual(portal.adult?.phone1Type, expectedPhone1Type, "phone1Type values do not match.")
        XCTAssertEqual(portal.adult?.phone2, expectedPhone2, "phone2 values do not match.")
        XCTAssertEqual(portal.adult?.phone2Type, expectedPhone2Type, "phone2Type values do not match.")
        XCTAssertEqual(portal.adult?.email, expectedEmail, "email values do not match.")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
