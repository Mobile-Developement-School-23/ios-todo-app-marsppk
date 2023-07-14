//
//  DataTaskExtentionTests.swift
//  toDoListTests
//
//  Created by Maria Slepneva on 07.07.2023.
//

import XCTest
@testable import toDoList

final class DataTaskExtentionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetItem() throws {
        let networkingService = DefaultNetworkingServiceWithExtention(token: "octactine")
        let item = try await networkingService.getItemExtention(id: "F093368A-3B2C-4CC9-9E2B-67E99E20B01C")
        XCTAssertEqual(item.id, "123", "Struct incorrect")
        XCTAssertEqual(item.text, "do homework", "Struct incorrect")
        XCTAssertEqual(item.deadline, nil, "Struct incorrect")
        XCTAssertEqual(item.importance, .usual, "Struct incorrect")
        XCTAssertEqual(item.isTaskComplete, false, "Struct incorrect")
        XCTAssertEqual(item.dateOfCreation, dateOfCreation, "Struct incorrect")
        XCTAssertEqual(item.dateOfChange, nil, "Struct incorrect")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
