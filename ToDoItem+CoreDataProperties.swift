//
//  ToDoItem+CoreDataProperties.swift
//  
//
//  Created by Maria Slepneva on 10.07.2023.
//
//

import Foundation
import CoreData

extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var id: String
    @NSManaged public var text: String
    @NSManaged public var dateOfCreation: Date
    @NSManaged public var deadline: Date?
    @NSManaged public var dateOfChange: Date?
    @NSManaged public var isTaskComplete: Bool
    @NSManaged public var importance: String

    var asTodoItem: TodoItem {
        let item = TodoItem(
            id: self.id,
            text: self.text,
            deadline: self.deadline,
            importance: Importance(rawValue: self.importance),
            isTaskComplete: self.isTaskComplete,
            dateOfCreation: self.dateOfCreation,
            dateOfChange: self.dateOfChange
        )
        return item
    }
}
