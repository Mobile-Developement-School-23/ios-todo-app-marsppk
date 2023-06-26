//
//  deleteButtonActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    @IBAction func buttonTapped(sender: UIButton) {
        fileCache.remove(id: toDoitem1.id)
        fileCache.saveAll(name: "test1.json")
        
        textView.text = ""
        importance = 0
        Switch.isOn = false
        segmentControl.selectedSegmentIndex = 1
        saveTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        deleteButton.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        
        stackWithDateAndDeadline.removeFromSuperview()
        separator1.removeFromSuperview()
        calendarView.removeFromSuperview()
    
        stackWithDateAndDeadline = UIStackView()
        stackWithDateAndDeadline.axis = .vertical
        stackWithDateAndDeadline.distribution = .fill
        stackWithDateAndDeadline.spacing = 0
        stackWithDateAndDeadline.addArrangedSubview(labelDeadline)
        
        [stackWithDateAndDeadline, Switch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack2.addArrangedSubview($0)
        }
        
        [horizontalStack1, stackSeparator1, horizontalStack2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            verticalStack.addArrangedSubview($0)
        }
        
        [textView, verticalStack, deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            verticalStack1.addArrangedSubview($0)
        }
    }
}
