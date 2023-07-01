//
//  toDoListTests.swift
//  toDoListTests
//
//  Created by Maria Slepneva on 12.06.2023.
//

import XCTest
@testable import toDoList

final class ToDoListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func formatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        return dateFormatter
    }

    func testWithId() throws {
        let dateFormatter = Formatter()
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let toDo = TodoItem(id: "123", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        XCTAssertEqual(Todo.id, "123", "Struct incorrect")
        XCTAssertEqual(Todo.text, "do homework", "Struct incorrect")
        XCTAssertEqual(Todo.deadline, nil, "Struct incorrect")
        XCTAssertEqual(Todo.importance, .usual, "Struct incorrect")
        XCTAssertEqual(Todo.isTaskComplete, false, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfCreation, dateOfCreation, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfChange, nil, "Struct incorrect")
    }

    func testWithoutId() throws {
        let dateFormatter = Formatter()
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let toDo = TodoItem(id: nil, text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        XCTAssertNotEqual(Todo.id, nil, "Struct incorrect")
        XCTAssertEqual(Todo.text, "do homework", "Struct incorrect")
        XCTAssertEqual(Todo.deadline, nil, "Struct incorrect")
        XCTAssertEqual(Todo.importance, .usual, "Struct incorrect")
        XCTAssertEqual(Todo.isTaskComplete, false, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfCreation, dateOfCreation, "Struct incorrect")
        XCTAssertEqual(Todo.dateOfChange, nil, "Struct incorrect")
    }

    func testParse1() throws {
        // test case: {"id":"345","text":"do homework","dateOfCreation":"2023-06-14 22:52:40","isTaskComplete": false}
        guard let path = Bundle.main.path(forResource: "test1", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let struc = TodoItem.parse(json: dict)
        XCTAssertEqual(struc?.id, "345", "JSON parsed incorrect")
        XCTAssertEqual(struc?.dateOfCreation, Formatter().date(from: "2023-06-14 22:52:40"), "JSON parsed incorrect")
        XCTAssertEqual(struc?.isTaskComplete, false, "JSON parsed incorrect")
    }

    func testParse2() throws {
        // test case: {"id":"345","dateOfCreation":"2023-06-14 22:52:40","isTaskComplete": false}
        guard let path = Bundle.main.path(forResource: "test2", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let struc = TodoItem.parse(json: dict)
        XCTAssertEqual(struc.self != nil, false, "JSON parsed incorrect")
    }

    func testParse3() throws {
        // test case: {"text":"do homework","dateOfCreation":"2023-06-14 22:52:40","isTaskComplete": false}
        guard let path = Bundle.main.path(forResource: "test3", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let struc = TodoItem.parse(json: dict)
        XCTAssertEqual(struc.self != nil, false, "JSON parsed incorrect")
    }

    func testParse4() throws {
        // test case: {"id":"345","text":"do homework","isTaskComplete": false}
        guard let path = Bundle.main.path(forResource: "test4", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let struc = TodoItem.parse(json: dict)
        XCTAssertEqual(struc.self != nil, false, "JSON parsed incorrect")
    }

    func testParse5() throws {
        // test case: {"id":"345","dateOfCreation":"2023-06-14 22:52:40}
        guard let path = Bundle.main.path(forResource: "test5", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let struc = TodoItem.parse(json: dict)
        XCTAssertEqual(struc.self != nil, false, "JSON parsed incorrect")
    }

    func testParse6() throws {
        // test case: empty file
        guard let path = Bundle.main.path(forResource: "test6", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let struc = TodoItem.parse(json: dict)
        XCTAssertEqual(struc.self != nil, false, "JSON parsed incorrect")
    }

    func testconvToJSON() throws {
        let dateFormatter = Formatter()
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let toDo = TodoItem(id: "123", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        guard let dict = Todo.json as [String: Any] else {return}
        XCTAssertEqual(dict["id"] as? String, "123", "Incorrect convertation to json")
        XCTAssertEqual(dict["text"] as? String, "do homework", "Incorrect convertation to json")
        XCTAssertEqual(dict["isTaskComplete"] as? Bool, false, "Incorrect convertation to json")
        XCTAssertEqual(dict["dateOfCreation"] as? String, "2023-06-14 22:52:40", "Incorrect convertation to json")
        XCTAssertEqual(dict["importance"] != nil, false, "Incorrect convertation to json")
        XCTAssertEqual(dict["deadline"] != nil, false, "Incorrect convertation to json")
    }

    // Tests for FileCache

    func testWrite() throws {
        let data = FileCache()
        let dateFormatter = Formatter()
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let toDo = TodoItem(id: "345", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        let toDo1 = TodoItem(id: "3485", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        data.add(item: Todo)
        data.add(item: Todo1)
        data.saveAll(name: "test.json")
    }

    func testLoad() throws {
        let data = FileCache()
        data.loadAll(name: "test.json")
    }

    func testRemove() throws {
        let data = FileCache()
        let dateFormatter = Formatter()
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let toDo = TodoItem(id: "345", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        data.add(item: Todo)
        data.remove(id: "345")
        XCTAssertEqual(data.items.count, 0, "Elements is not delete")
    }

    func testDublicateID() throws {
        let data = FileCache()
        let dateFormatter = Formatter()
        let dateOfCreation = dateFormatter.date(from: "2023-06-14 22:52:40")!
        let toDo = TodoItem(id: "345", text: "do homework", deadline: nil, importance: Importance("usual"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        let toDo1 = TodoItem(id: "345", text: "new task", deadline: nil, importance: Importance("important"), isTaskComplete: false, dateOfCreation: dateOfCreation, dateOfChange: nil)
        data.add(item: Todo)
        data.add(item: Todo1)
        XCTAssertEqual(data.items.count, 1, "ID is dublicate")
        XCTAssertEqual(data.items[0].text, "new task", "Data is not rewrited")
    }
}
