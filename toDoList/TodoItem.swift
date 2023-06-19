import Foundation

enum Importance {
    case important
    case usual
    case unimportant
    init(_ val: String) {
        switch val {
            case "important"  : self = .important
            case "unimportant": self = .unimportant
            case _ : self = .usual
        }
    }
}

struct TodoItem {
    let id: String
    let text: String
    let deadline: Date?
    let importance: Importance
    let isTaskComplete: Bool
    let dateOfCreation: Date
    let dateOfChange: Date?
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
        guard let dict = json as? [String:Any] else { return nil }
        guard let id = dict["id"] as? String else { return nil }
        guard let text = dict["text"] as? String else { return nil }
        guard let isTaskComplete = dict["isTaskComplete"] as? Bool else { return nil }
        guard let date = dict["dateOfCreation"] as? String else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        var deadline: Date? = nil
        if dict["deadline"] != nil {
            deadline = dateFormatter.date(from: dict["deadline"] as! String)!
        }
        var importance = "usual"
        if dict["importance"] != nil {
            importance = dict["importance"] as! String
        }
        let dateOfCreation = dateFormatter.date(from: date)!
        var dateOfChange: Date? = nil
        if dict["dateOfChange"] != nil {
            dateOfChange = dateFormatter.date(from: dict["dateOfChange"] as! String)!
        }
        let item = TodoItem(id: id, text: text, deadline: deadline, importance: Importance(importance), isTaskComplete: isTaskComplete, dateOfCreation: dateOfCreation, dateOfChange: dateOfChange)
        return item
    }
    
    var json: Any {
        var properties: [String:Any] = [:]
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
