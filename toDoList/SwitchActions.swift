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
            
            [horizontalStack1, separator, horizontalStack2].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack.addArrangedSubview($0)
            }
            
            [textView, verticalStack, deleteButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack1.addArrangedSubview($0)
            }
            
            
            NSLayoutConstraint.activate([
                horizontalStack1.heightAnchor.constraint(equalToConstant: 54),
                horizontalStack2.heightAnchor.constraint(equalToConstant: 54),
                stackWithDateAndDeadline.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
                Switch.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -12),
                Switch.heightAnchor.constraint(equalToConstant: Switch.frame.height),
                Switch.widthAnchor.constraint(equalToConstant: Switch.frame.width)
            ])
            
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
            
            [horizontalStack1, separator, horizontalStack2].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack.addArrangedSubview($0)
            }
            
            [textView, verticalStack, deleteButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack1.addArrangedSubview($0)
            }
            
            NSLayoutConstraint.activate([
                horizontalStack1.heightAnchor.constraint(equalToConstant: 54),
                horizontalStack2.heightAnchor.constraint(equalToConstant: 54),
                stackWithDateAndDeadline.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
                Switch.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -12),
                Switch.heightAnchor.constraint(equalToConstant: Switch.frame.height),
                Switch.widthAnchor.constraint(equalToConstant: Switch.frame.width)
            ])
            flag_calendar = true
        }
    }
}
