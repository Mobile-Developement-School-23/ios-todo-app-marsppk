//
//  toDoListTests.swift
//  toDoListTests
//
//  Created by Maria Slepneva on 12.06.2023.
//

import XCTest
@testable import toDoList

final class toDoListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testWithId() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let Todo = TodoItem(id: "123", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        XCTAssertEqual(Todo.id, "123", "Struct incorrect")
        XCTAssertEqual(Todo.text, "do homework", "Struct incorrect")
        XCTAssertEqual(Todo.deadline, nil, "Struct incorrect")
        XCTAssertEqual(Todo.importance, .usual, "Struct incorrect")
        XCTAssertEqual(Todo.isTaskComplete, false, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfCreation, dateOfCreation, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfChange, nil, "Struct incorrect")
    }
    
    func testWithoutId() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let Todo = TodoItem(id: nil, text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        XCTAssertNotEqual(Todo.id, nil, "Struct incorrect")
        XCTAssertEqual(Todo.text, "do homework", "Struct incorrect")
        XCTAssertEqual(Todo.deadline, nil, "Struct incorrect")
        XCTAssertEqual(Todo.importance, .usual, "Struct incorrect")
        XCTAssertEqual(Todo.isTaskComplete, false, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfCreation, dateOfCreation, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfChange, nil, "Struct incorrect")
    }

    func testParse() throws {
        guard let path = Bundle.main.path(forResource: "test", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        let json = try! String(data: Data(contentsOf: url), encoding: .utf8)
        let struc = TodoItem.parse(json: json)
        XCTAssertEqual(struc?.id, "123", "JSON parsed incorrect")
    }
    
    func testconvToJSON() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let Todo = TodoItem(id: "123", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testWrite() throws {
        let data = FileCache()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let Todo = TodoItem(id: "345", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        let Todo1 = TodoItem(id: "3485", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        data.add(item: Todo)
        data.add(item: Todo1)
        data.saveAll(name: "test.json")
    }
    
    func testLoad() throws {
        let data = FileCache()
        data.loadAll(name: "test.json")
    }
}
