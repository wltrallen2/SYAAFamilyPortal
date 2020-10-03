//
//  SYAAFamilyPortalTests.swift
//  SYAAFamilyPortalTests
//
//  Created by Walter Allen on 9/30/20.
//

import XCTest
@testable import SYAAFamilyPortal

class SYAAFamilyPortalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPersonContainsData() throws {
        XCTAssert(personData.count == 4)
    }

    func testStudentDecodingProperly() throws {
        let student = personData[2]
        XCTAssert(student.student != nil)
        XCTAssert(student.firstName == "Anya")
        XCTAssert(student.student!.currentGrade == 2)
    }
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
