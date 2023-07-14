//
//  FileCache.swift
//  toDoList
//
//  Created by Maria Slepneva on 15.06.2023.
//

import Foundation
import UIKit
import CoreData

final class FileCache {
    private(set) var items = [TodoItem]()

    private(set) var context: NSManagedObjectContext?

    func add(item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    func setContext(context: NSManagedObjectContext) {
        self.context = context
    }

    func remove(id: String) {
        self.items.removeAll { $0.id == id }
    }

    func saveAll(name: String) {
        guard let documentDirectoryUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
        else { return }

        let fileUrl = documentDirectoryUrl.appendingPathComponent(name)
        var dict: [String: Array] = ["items": []]
        for item in 0..<items.count {
            let data = items[item].json
            dict["items"]?.append(data)
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }

    func loadAll(name: String) {
        guard let documentDirectoryUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
        else { return }

        self.items = [TodoItem]()
        let url = documentDirectoryUrl.appendingPathComponent(name)
        guard let data = try? Data(contentsOf: url) else { return }

        if let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            guard let items = dict["items"] as? NSArray else { return }

            for item in items {
                let note = TodoItem.parse(json: item)
                if let note = note {
                    self.add(item: note)
                }
            }
        }
    }

    func getAllItemsCoreData() {
        self.items = []
        do {
            let items = try context!.fetch(ToDoItem.fetchRequest())
            for item in items {
                self.add(item: item.asTodoItem)
            }
        } catch {
            // error
        }
    }

    func deleteItemCoreData(deleteItem: TodoItem) {
        do {
            let items = try context!.fetch(ToDoItem.fetchRequest())
            for item in items {
                if item.id == deleteItem.id {
                    context?.delete(item)
                }
            }
            try context?.save()
        } catch {
            // error
        }
    }

    func updateItemCoreData(newItem: TodoItem) {
        do {
            let items = try context!.fetch(ToDoItem.fetchRequest())
            for item in items {
                if item.id == newItem.id {
                    item.deadline = newItem.deadline
                    item.text = newItem.text
                    item.isTaskComplete = newItem.isTaskComplete
                    item.dateOfCreation = newItem.dateOfCreation
                    item.dateOfChange = newItem.dateOfChange
                    item.importance = newItem.importance.rawValue
                }
            }
            try context?.save()
        } catch {
            // error
        }
    }

    func createItemCoreData(item: TodoItem) {
        let newItem = ToDoItem(context: context!)
        newItem.id = item.id
        newItem.text = item.text
        newItem.importance = item.importance.rawValue
        newItem.isTaskComplete = item.isTaskComplete
        newItem.dateOfChange = item.dateOfChange
        newItem.dateOfCreation = item.dateOfCreation
        newItem.deadline = item.deadline
        do {
            try context?.save()
        } catch {
            // error
        }
    }
}
