//
//  viewActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    
    func background() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
    }
    
    func orientation() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        fileCache.loadAll(name: "test1.json")
        if fileCache.items.count != 0 {
            toDoitem1 = fileCache.items[0]
        }
        segmentControl.setImage(imageLow, forSegmentAt: 0)
        segmentControl.setImage(imageImportant, forSegmentAt: 2)
        deleteButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped1))
        saveTask.isUserInteractionEnabled = true
        saveTask.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        background()
        orientation()
        textView.delegate = self
        textView.returnKeyType = .done
        if (toDoitem1.text != ""){
            textView.text = toDoitem1.text
            deleteButton.setTitleColor(UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0), for: .normal)
            textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        if (toDoitem1.importance == .unimportant) {
            segmentControl.selectedSegmentIndex = 0
        }
        if (toDoitem1.importance == .usual) {
            segmentControl.selectedSegmentIndex = 1
        }
        if (toDoitem1.importance == .important) {
            segmentControl.selectedSegmentIndex = 2
        }
        separator.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let horizontalStack1 = UIStackView()
        horizontalStack1.alignment = .center
        horizontalStack1.axis = .horizontal
        horizontalStack1.distribution = UIStackView.Distribution.equalSpacing
        [labelImportance, segmentControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack1.addArrangedSubview($0)
        }
        
        horizontalStack1.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalStack2 = UIStackView()
        horizontalStack2.axis = .horizontal
        horizontalStack2.distribution = UIStackView.Distribution.equalSpacing
        horizontalStack2.alignment = .center
        
        let stackWithDateAndDeadline = UIStackView()
        stackWithDateAndDeadline.axis = .vertical
        stackWithDateAndDeadline.distribution = .fill
        stackWithDateAndDeadline.spacing = 0
        stackWithDateAndDeadline.addArrangedSubview(labelDeadline)
        stackWithDateAndDeadline.addArrangedSubview(labelDate)
        [stackWithDateAndDeadline, Switch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack2.addArrangedSubview($0)
        }
        horizontalStack2.translatesAutoresizingMaskIntoConstraints = false
        separator1.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        
        [cancelTask, labelTask, saveTask].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack.addArrangedSubview($0)
        }
        
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
        
        [horizontalStack, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(horizontalStack)
        view.addSubview(scrollView)
        
        setupConstrains()
        
        horizontalStack1.heightAnchor.constraint(equalToConstant: 54).isActive = true
        horizontalStack2.heightAnchor.constraint(equalToConstant: 54).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: verticalStack1.leadingAnchor).isActive = true
        NSLayoutConstraint.activate([
            labelImportance.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
            labelImportance.heightAnchor.constraint(equalToConstant: labelImportance.frame.height),
            labelImportance.widthAnchor.constraint(equalToConstant: labelImportance.frame.width),
            
            segmentControl.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -12),
            segmentControl.heightAnchor.constraint(equalToConstant: segmentControl.frame.height),
            segmentControl.widthAnchor.constraint(equalToConstant: segmentControl.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            stackWithDateAndDeadline.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
            Switch.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -12),
            Switch.heightAnchor.constraint(equalToConstant: Switch.frame.height),
            Switch.widthAnchor.constraint(equalToConstant: Switch.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: horizontalStack1.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -16)
        ])
        if (toDoitem1.deadline != nil) {
            Switch.isOn = true
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            let string_date = formatter.string(from: toDoitem1.deadline!)
            labelDate.text = string_date
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
            stackWithDateAndDeadline.addArrangedSubview(labelDate)
            
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            
            labelDate.isUserInteractionEnabled = true
            labelDate.addGestureRecognizer(tapGesture1)
            
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
}
