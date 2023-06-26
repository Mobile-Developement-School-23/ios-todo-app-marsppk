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
        saveTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        deleteButton.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        scrollView.removeFromSuperview()
        segmentControl.selectedSegmentIndex = 1
        let horizontalStack1 = UIStackView()
        
        let horizontalStack2 = UIStackView()
        horizontalStack2.axis = .horizontal
        horizontalStack2.distribution = UIStackView.Distribution.equalSpacing
        horizontalStack2.alignment = .center
        
        let stackWithDateAndDeadline = UIStackView()
        stackWithDateAndDeadline.axis = .vertical
        stackWithDateAndDeadline.distribution = .fill
        stackWithDateAndDeadline.spacing = 0
        stackWithDateAndDeadline.addArrangedSubview(labelDeadline)
        [stackWithDateAndDeadline, Switch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack2.addArrangedSubview($0)
        }
        separator1.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        
        [horizontalStack1, separator, horizontalStack2].forEach {
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
        
        view.addSubview(scrollView)
        
        setupConstrains()
        
        horizontalStack1.heightAnchor.constraint(equalToConstant: 54).isActive = true
        horizontalStack2.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        NSLayoutConstraint.activate([
            stackWithDateAndDeadline.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
            Switch.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -12),
            Switch.heightAnchor.constraint(equalToConstant: Switch.frame.height),
            Switch.widthAnchor.constraint(equalToConstant: Switch.frame.width)
        ])
        
    }
}
