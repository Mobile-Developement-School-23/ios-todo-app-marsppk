import Foundation

enum Importance {
    case important
    case usual
    case unimportant
    init(_ val: String) {
        switch val {
            case "important": self = .important
            case "unimportant": self = .unimportant
            case _: self = .usual
        }
    }
}

struct TodoItem {
    let id: String
    var text: String
    var deadline: Date?
    var importance: Importance
    var isTaskComplete: Bool
    var dateOfCreation: Date
    var dateOfChange: Date?
    init(id: String?, text: String, deadline: Date?, importance: Importance?, isTaskComplete: Bool, dateOfCreation: Date, dateOfChange: Date?) {
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
            self.importance = Importance("usual")
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
        let item = TodoItem(id: id, text: text, deadline: deadline, importance: Importance(importance), isTaskComplete: isTaskComplete, dateOfCreation: dateOfCreation, dateOfChange: dateOfChange)
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
        if self.importance == .important {
            properties["importance"] = "important"
        }
        if self.importance == .unimportant {
            properties["importance"] = "unimportant"
        }
        properties["dateOfCreation"] = dateFormatter.string(from: self.dateOfCreation)
        if let dateOfChange = self.dateOfChange {
            properties["dateOfChange"] = dateFormatter.string(from: dateOfChange)
        }
        return properties
    }
}
