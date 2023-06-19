//
//  FileCache.swift
//  toDoList
//
//  Created by Maria Slepneva on 15.06.2023.
//

import Foundation

class FileCache {
    private(set) var items = [TodoItem]()
    
    func add(item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    func remove(id: String) {
        self.items.removeAll { $0.id == id }
    }
    
    func saveAll(name: String) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent(name)
        var dict: [String:Array] = ["items":[]]
        for i in 0..<items.count {
            let data = items[i].json
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
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        self.items = [TodoItem]()
        let url = documentDirectoryUrl.appendingPathComponent(name)
        guard let data = try? Data(contentsOf: url) else { return }
        
        if let dict = try? JSONSerialization.jsonObject(with: data) as? [String : Any] {
            guard let item = dict["items"] as? NSArray else { return }
            
            for i in item {
                let note = TodoItem.parse(json: i)
                if let note = note {
                    self.add(item:note)
                }
            }
        }
    }
}
