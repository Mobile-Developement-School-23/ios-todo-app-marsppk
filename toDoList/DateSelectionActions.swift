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
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            let string_date = formatter.string(from: components!)
            labelDate.text = string_date
            separator1.removeFromSuperview()
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
            let tomorrowComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow!)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            let string_date = formatter.string(from: tomorrow!)
            labelDate.text = string_date
            dateSelection.setSelected(tomorrowComponents, animated: true)
        }
        else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            let date = formatter.date(from: labelDate.text!)
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date!)
            dateSelection.setSelected(components, animated: true)
        }
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        labelDate.addGestureRecognizer(tapGesture1)
    }
    
    @objc func labelTapped() {
        if flag_calendar {
            setupDate()

            [separator1, calendarView].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack.addArrangedSubview($0)
            }
            
            [textView, verticalStack, deleteButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                verticalStack1.addArrangedSubview($0)
            }
            
            verticalStack1.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(verticalStack1)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                separator1.topAnchor.constraint(equalTo: horizontalStack2.bottomAnchor),
                separator1.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
                separator1.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -16),
                separator1.heightAnchor.constraint(equalToConstant: 0.5)
            ])
            
            NSLayoutConstraint.activate([
                calendarView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
                calendarView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -16),
                calendarView.heightAnchor.constraint(equalToConstant: 300),
                calendarView.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 8)
            ])
            flag_calendar = false
        }
        else {
            separator1.removeFromSuperview()
            calendarView.removeFromSuperview()
            flag_calendar = true
        }
    }
}
