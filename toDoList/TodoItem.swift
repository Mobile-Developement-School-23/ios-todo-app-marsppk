import Foundation

enum Importance: String {
    case important = "important"
    case usual = "usual"
    case unimportant = "unimportant"
}

struct TodoItem {
    let id: String
    var text: String
    var deadline: Date?
    var importance: Importance
    var isTaskComplete: Bool
    var dateOfCreation: Date
    var dateOfChange: Date?
    init(
        id: String?,
        text: String,
        deadline: Date?,
        importance: Importance?,
        isTaskComplete: Bool,
        dateOfCreation: Date,
        dateOfChange: Date?
    ) {
        if let id = id {
            self.id = id
        } else {
            self.id = UUID().uuidString
        }
        self.text = text
        self.deadline = deadline
        if let importance = importance {
            self.importance = importance
        } else {
            self.importance = Importance(rawValue: "usual") ?? .usual
        }
        self.isTaskComplete = isTaskComplete
        self.dateOfCreation = dateOfCreation
        self.dateOfChange = dateOfChange
    }
}

extension TodoItem {

    static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any] else { return nil }
        guard let id = dict["id"] as? String else { return nil }
        guard let text = dict["text"] as? String else { return nil }
        guard let isTaskComplete = dict["isTaskComplete"] as? Bool else { return nil }
        guard let date = dict["dateOfCreation"] as? String else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        var deadline: Date?
        if let dl = dict["deadline"] {
            deadline = dateFormatter.date(from: dl as? String ?? "")!
        }
        let importance = dict["importance"] as? String ?? "usual"
        let dateOfCreation = dateFormatter.date(from: date)!
        var dateOfChange: Date?
        if let date = dict["dateOfChange"] {
            dateOfChange = dateFormatter.date(from: date as? String ?? "")!
        }
        let item = TodoItem(
            id: id,
            text: text,
            deadline: deadline,
            importance: Importance(rawValue: importance),
            isTaskComplete: isTaskComplete,
            dateOfCreation: dateOfCreation,
            dateOfChange: dateOfChange
        )
        return item
    }

    var json: Any {
        var properties: [String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        properties["id"] = self.id
        properties["text"] = self.text
        properties["isTaskComplete"] = self.isTaskComplete
        if let deadline = self.deadline {
            properties["deadline"] = dateFormatter.string(from: deadline)
        }
        if self.importance != .usual {
            properties["importance"] = self.importance.rawValue
        }
        properties["dateOfCreation"] = dateFormatter.string(from: self.dateOfCreation)
        if let dateOfChange = self.dateOfChange {
            properties["dateOfChange"] = dateFormatter.string(from: dateOfChange)
        }
        return properties
    }

    static func parseCoreData(item: ToDoItem) -> TodoItem? {
        let item = TodoItem(
            id: item.id,
            text: item.text,
            deadline: item.deadline,
            importance: Importance(rawValue: item.importance),
            isTaskComplete: item.isTaskComplete,
            dateOfCreation: item.dateOfCreation,
            dateOfChange: item.dateOfChange
        )
        return item
    }

    var asNetworking: ToDoItemNetworking {
        var importance = "basic"
        var deadline: Int64?
        var changedAt: Int64 = Int64(Date().timeIntervalSince1970)

        if self.importance == .unimportant {
            importance = "low"
        } else if self.importance == .important {
            importance = "important"
        }
        if let deadlineFromLocal = self.deadline {
            deadline = Int64(deadlineFromLocal.timeIntervalSince1970)
        }
        if let modificationDateFromLocal = self.dateOfChange {
            changedAt = Int64(modificationDateFromLocal.timeIntervalSince1970)
        }

        let asNetworking = ToDoItemNetworking(
            id: self.id,
            text: self.text,
            importance: importance,
            deadline: deadline,
            done: self.isTaskComplete,
            color: nil,
            createdAt: Int64(self.dateOfCreation.timeIntervalSince1970),
            changedAt: changedAt,
            lastUpdatedBy: ListOfTasksViewController.deviceID
        )
        return asNetworking
    }
}
