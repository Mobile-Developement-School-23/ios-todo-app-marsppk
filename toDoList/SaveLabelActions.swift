//
//  saveLabelActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    @objc func labelTapped1() {
        toDoitem1.text = textView.text
        if importance == 0 {
            toDoitem1.importance = .usual
        } else if importance == 1 {
            toDoitem1.importance = .important
        } else {
            toDoitem1.importance = .unimportant
        }
        if Switch.isOn {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
            toDoitem1.deadline = formatter.date(from: labelDate.text!)
        }
        else {
            toDoitem1.deadline = nil
        }
        toDoitem1.dateOfChange = Date()
        fileCache.add(item: toDoitem1)
        fileCache.saveAll(name: "test1.json")
        saveTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    }
}