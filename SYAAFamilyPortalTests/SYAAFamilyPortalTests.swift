//
//  SYAAFamilyPortalTests.swift
//  SYAAFamilyPortalTests
//
//  Created by Walter Allen on 9/30/20.
//

import XCTest
@testable import SYAAFamilyPortal

class SYAAFamilyPortalTests: XCTestCase {
    let portal = Portal()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testProductionData() throws {
        portal.setProductions()
        XCTAssert(portal.productions.count == 2)
        
        let production = portal.productions[0]
        let rehearsal = production.rehearsals[0]
        XCTAssert(production.id == rehearsal.productionId)
        XCTAssert(production.title == portal.getProductionForRehearsal(rehearsal)?.title)
    }
    
    func testPortalMethods() throws {
        portal.setProductions()
        let production = productionData[0]
        let rehearsal = production.rehearsals[0]
        XCTAssert(portal.getProductionForRehearsal(rehearsal)?.id == 1)
    }
    
    func testPersonContainsData() throws {
//        XCTAssert(personData.count == 4)
    }

    func testStudentDecodingProperly() throws {
//        let student = personData[2]
//        XCTAssert(student.student != nil)
//        XCTAssert(student.firstName == "Anya")
//        XCTAssert(student.student!.currentGrade == 2)
    }
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
