//
//  ViewController.swift
//  toDoList
//
//  Created by Maria Slepneva on 12.06.2023.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
    
    // Init
    
    
    var toDoitem1: TodoItem = TodoItem(id: UUID().uuidString, text: "String", deadline: nil, importance: .usual, isTaskComplete: false, dateOfCreation: Date(), dateOfChange: nil)
    let separator = UIView()
    let separator1 = UIView()
        
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        sv.contentInset = .zero
        sv.alwaysBounceVertical = true
        sv.isScrollEnabled = true
        return sv
    }()
    
    let calendarView: UICalendarView = {
        var cv = UICalendarView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.calendar = .current
        cv.locale = .current
        cv.fontDesign = .rounded
        cv.calendar.firstWeekday = 2
        cv.availableDateRange = DateInterval.init(start: .now, end: Date.distantFuture)
        return cv
    }()
    
    let Switch: UISwitch = {
        let s = UISwitch()
        s.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        return s
    }()
    
    var imageImportant: UIImage {
        let ii = UIImage(named: "imp")?.withRenderingMode(.alwaysOriginal)
        return ii!
    }
    var imageLow: UIImage {
        let il = UIImage(named: "low")?.withRenderingMode(.alwaysOriginal)
        return il!
    }
    
    let labelDate: UILabel = {
        let ld = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        ld.frame = labelFrame
        ld.font = UIFont(name: "HelveticaNeue", size: 15)
        ld.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        return ld
    }()
    
    let labelImportance: UILabel = {
        let li = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        li.frame = labelFrame
        li.text = "Важность"
        li.font = UIFont(name: "HelveticaNeue", size: 17)
        li.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return li
    }()
    
    let labelDeadline: UILabel = {
        let ld = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        ld.frame = labelFrame
        ld.text = "Сделать до"
        ld.font = UIFont(name: "HelveticaNeue", size: 17)
        ld.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return ld
    }()
    
    let labelTask: UILabel = {
        let lt = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        lt.frame = labelFrame
        lt.text = "Дело"
        lt.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        lt.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return lt
    }()
    
    let saveTask: UILabel = {
        let st = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        st.frame = labelFrame
        st.text = "Сохранить"
        st.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        st.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        return st
    }()
    
    let cancelTask: UILabel = {
        let ct = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        ct.frame = labelFrame
        ct.text = "Отменить"
        ct.font = UIFont(name: "HelveticaNeue", size: 17)
        ct.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        return ct
    }()
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.frame = CGRect(origin: CGPoint(), size: CGSize(width: 330, height: 120))
        tv.font = UIFont(name: "HelveticaNeue", size: 17)
        tv.text = "Что надо сделать?"
        tv.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        tv.isScrollEnabled = false
        tv.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tv.layer.cornerRadius = 16
        tv.textContainer.lineFragmentPadding = 17
        tv.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        return tv
    }()
    
    let deleteButton: UIButton = {
        let db = UIButton()
        db.layer.cornerRadius = 16
        db.frame.size.height = 56
        db.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        db.setTitle("Удалить", for: .normal)
        db.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        db.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        db.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return db
    }()
    
    let verticalStack: UIStackView = {
        let vstack = UIStackView()
        vstack.distribution = .equalSpacing
        vstack.axis = .vertical
        vstack.backgroundColor = .white
        vstack.layer.cornerRadius = 16
        return vstack
    }()
    
    let verticalStack1: UIStackView = {
        let vstack = UIStackView()
        vstack.distribution = .equalSpacing
        vstack.alignment = UIStackView.Alignment.fill
        vstack.axis = .vertical
        vstack.spacing = 16
        return vstack
    }()
    
    let horizontalStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = UIStackView.Distribution.equalSpacing
        return hstack
    }()
    
    
    // Functions
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Что надо сделать?" {
            textView.text = ""
            textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            textView.font = UIFont(name: "HelveticaNeue", size: 17)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            textView.font = UIFont(name: "HelveticaNeue", size: 17)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.invalidateIntrinsicContentSize()
        if textView.text != "" {
            deleteButton.setTitleColor(UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0), for: .normal)
            saveTask.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        }
        else {
            saveTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            deleteButton.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        }
    }
    
    func setupSegmentControl() -> UISegmentedControl {
        let items = ["Картинка 1", "нет", "Картинка 2"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 1
        let font = UIFont(name: "HelveticaNeue", size: 16)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentControl.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        segmentControl.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        segmentControl.setImage(imageLow, forSegmentAt: 0)
        segmentControl.setImage(imageImportant, forSegmentAt: 2)
        segmentControl.frame = CGRect(x: 0, y: 0, width: 150, height: 36)
        return segmentControl
    }
    
    func setupHorizontalStack1() -> UIStackView {
        let horizontalStack1 = UIStackView()
        let segmentControl = setupSegmentControl()
        horizontalStack1.alignment = .center
        horizontalStack1.axis = .horizontal
        horizontalStack1.distribution = UIStackView.Distribution.equalSpacing
        [labelImportance, segmentControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack1.addArrangedSubview($0)
        }
        NSLayoutConstraint.activate([
            labelImportance.topAnchor.constraint(equalTo: horizontalStack1.topAnchor, constant: 8),
            labelImportance.leadingAnchor.constraint(equalTo: horizontalStack1.leadingAnchor, constant: 16),
            labelImportance.heightAnchor.constraint(equalToConstant: labelImportance.frame.height),
            labelImportance.widthAnchor.constraint(equalToConstant: labelImportance.frame.width),
            segmentControl.topAnchor.constraint(equalTo: horizontalStack1.topAnchor, constant: 10),
            segmentControl.trailingAnchor.constraint(equalTo: horizontalStack1.trailingAnchor, constant: -12),
            segmentControl.heightAnchor.constraint(equalToConstant: segmentControl.frame.height),
            segmentControl.widthAnchor.constraint(equalToConstant: segmentControl.frame.width)
        ])
        horizontalStack1.translatesAutoresizingMaskIntoConstraints = false
        return horizontalStack1
    }
    
    func setupHorizontalStack2() -> UIStackView {
        let horizontalStack2 = UIStackView()
        horizontalStack2.axis = .horizontal
        horizontalStack2.distribution = UIStackView.Distribution.equalSpacing
        horizontalStack2.alignment = .center
        [labelDeadline, Switch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack2.addArrangedSubview($0)
        }
        horizontalStack2.translatesAutoresizingMaskIntoConstraints = false
        return horizontalStack2
    }
    
    func setupConstrains() {
        NSLayoutConstraint.activate([
            horizontalStack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            horizontalStack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            horizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 35),
            verticalStack1.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalStack1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            verticalStack1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            verticalStack1.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),
            verticalStack1.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let components = dateComponents?.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        let string_date = formatter.string(from: components!)
        labelDate.text = string_date
        scrollView.removeFromSuperview()
        
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

    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
    func background() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
    }
    
    func orientation() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
    }
    
    func setupDate() {
        let selectedDate = calendarView.calendar.date(byAdding: .day, value: 1, to: Date())
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let tomorrowComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow!)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        let string_date = formatter.string(from: tomorrow!)
        labelDate.text = string_date
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        dateSelection.setSelected(tomorrowComponents, animated: true)
    }

    
    override func viewDidLoad() {
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
            textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        
        separator.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let horizontalStack1 = UIStackView()
        let segmentControl = setupSegmentControl()
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
    }
    
    @objc func switchChanged(switch: UISwitch) {
        if Switch.isOn {
            setupDate()
            scrollView.removeFromSuperview()

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
        else {
            setupDate()
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.portrait
        }
    
    @objc func labelTapped1() {
//        let item = TodoItem(id: nil, text: textView.text, deadline: labelDate.t, importance: <#T##Importance?#>, isTaskComplete: <#T##Bool#>, dateOfCreation: <#T##Date#>, dateOfChange: <#T##Date?#>)
    }
    
    @objc func labelTapped() {
        setupDate()
        scrollView.removeFromSuperview()
        
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
        
        [horizontalStack1, separator, horizontalStack2, separator1, calendarView].forEach {
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
        
            NSLayoutConstraint.activate([
                separator.topAnchor.constraint(equalTo: horizontalStack1.bottomAnchor),
                separator.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
                separator.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -16)
            ])
        
            separator1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            NSLayoutConstraint.activate([
                separator1.topAnchor.constraint(equalTo: horizontalStack2.bottomAnchor),
                separator1.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
                separator1.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -16)
            ])

            NSLayoutConstraint.activate([
                calendarView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
                calendarView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -16),
                calendarView.heightAnchor.constraint(equalToConstant: 300),
                calendarView.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 8)
            ])
    }
}
