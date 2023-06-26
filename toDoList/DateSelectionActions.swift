//
//  dateSelectionActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let dateComponents {
            let dateSelection = UICalendarSelectionSingleDate(delegate: self)
            let components = dateComponents.date
            if let components {
                let string_date = formatter.string(from: components)
                labelDate.text = string_date
            }
            stackSeparator2.removeFromSuperview()
            calendarView.removeFromSuperview()
            flag_calendar = true
            dateSelection.setSelected(dateComponents, animated: true)
            if textView.text != "Что надо сделать?" && textView.text != "" {
                saveTask.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            }
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
    func setupDate() {
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        if labelDate.text == nil {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            if let tomorrow {
                let tomorrowComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
                let string_date = formatter.string(from: tomorrow)
                labelDate.text = string_date
                dateSelection.setSelected(tomorrowComponents, animated: true)
            }
        }
        else {
            if let dateLabel = labelDate.text {
                let date = formatter.date(from: dateLabel)
                if let date {
                    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                    dateSelection.setSelected(components, animated: true)
                }
            }
        }
    }
    
    @objc func labelTapped() {
        if flag_calendar {
            setupDate()
            
            stackSeparator2.addArrangedSubview(separator1)
            separator1.translatesAutoresizingMaskIntoConstraints = false
            
            [stackSeparator2, calendarView].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack.addArrangedSubview($0)
            }
            
            [textView, verticalStack, deleteButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack1.addArrangedSubview($0)
            }
            
            scrollView.addSubview(verticalStack1)
            
            NSLayoutConstraint.activate([
                separator1.topAnchor.constraint(equalTo: horizontalStack2.bottomAnchor),
                separator1.heightAnchor.constraint(equalToConstant: 0.5)
            ])
            
            flag_calendar = false
        }
        else {
            stackSeparator2.removeFromSuperview()
            calendarView.removeFromSuperview()
            flag_calendar = true
        }
    }
}
