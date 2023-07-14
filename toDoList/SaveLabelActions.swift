//
//  saveLabelActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

func createToDoItem() -> TodoItem {
    let toDoitem: TodoItem = TodoItem(id: UUID().uuidString, text: "", deadline: nil, importance: .usual, isTaskComplete: false, dateOfCreation: Date(), dateOfChange: nil)
    return toDoitem
}

extension ViewController {
    @objc func labelTapped1() {
        if saveTask.textColor == UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) {
            var toDoitem = createToDoItem()
            if let cell = tappedCell {
                toDoitem = cell
            }
            toDoitem.text = textView.text
            if importance == 0 {
                toDoitem.importance = .usual
            } else if importance == 1 {
                toDoitem.importance = .important
            } else {
                toDoitem.importance = .unimportant
            }
            if switchButton.isOn {
                formatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
                if let date = labelDate.text {
                    toDoitem.deadline = formatter.date(from: date)
                }
            } else {
                toDoitem.deadline = nil
            }
            toDoitem.isTaskComplete = false
            toDoitem.dateOfChange = Date()
            saveTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            fileCache.createItemCoreData(item: toDoitem)
            delegate?.didSaveNote()
            dismiss(animated: true, completion: nil)
        }
    }
}
