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
        super.viewDidLoad()
        
        background()
        orientation()
        
        textView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped1))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        Switch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        saveTask.isUserInteractionEnabled = true
        labelDate.isUserInteractionEnabled = true
        saveTask.addGestureRecognizer(tapGesture)
        labelDate.addGestureRecognizer(tapGesture1)
        stackSeparator1.addArrangedSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        fileCache.loadAll(name: "test1.json")
        
        if fileCache.items.count != 0 {
            toDoitem1 = fileCache.items[0]
        }
        
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
        
        setImages()
        
        [labelImportance, segmentControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack1.addArrangedSubview($0)
        }
        
        [labelDeadline, labelDate].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackWithDateAndDeadline.addArrangedSubview($0)
        }

        [stackWithDateAndDeadline, Switch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack2.addArrangedSubview($0)
        }
        
        [cancelTask, labelTask, saveTask].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack.addArrangedSubview($0)
        }
        
        [horizontalStack1, stackSeparator1, horizontalStack2].forEach {
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
            view.addSubview($0)
        }
        
        setupConstrains()
        
        if (toDoitem1.deadline != nil) {
            Switch.isOn = true
            let string_date = formatter.string(from: toDoitem1.deadline!)
            labelDate.text = string_date
            stackWithDateAndDeadline.addArrangedSubview(labelDate)
        }
    }
}
