//
//  switchActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    @objc func switchChanged(switch: UISwitch) {
        if Switch.isOn {
            setupDate()
            
            stackWithDateAndDeadline.addArrangedSubview(labelDeadline)
            stackWithDateAndDeadline.addArrangedSubview(labelDate)
            
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
        else {
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
            flag_calendar = true
        }
    }
}
