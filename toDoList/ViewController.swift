//
//  ViewController.swift
//  toDoList
//
//  Created by Maria Slepneva on 12.06.2023.
//

import UIKit

protocol ViewControllerDelegate: class {
    func didSaveNote()
}

class ViewController: UIViewController, UITextViewDelegate, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

    var tappedCell: TodoItem?

    let context: AppDelegate? = nil

    var fileCache = FileCache()

    var importance = 0

    var isTaskComplete = false

    weak var delegate: ViewControllerDelegate?

    let segmentControl: UISegmentedControl = {
        let items = ["Картинка 1", "нет", "Картинка 2"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 1
        let font = UIFont(name: "HelveticaNeue", size: 16)
        if let font {
            segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        segmentControl.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        segmentControl.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        segmentControl.frame = CGRect(x: 0, y: 0, width: 150, height: 36)
        return segmentControl
    }()

    let horizontalStack1: UIStackView = {
        let hs1 = UIStackView()
        hs1.isLayoutMarginsRelativeArrangement = true
        hs1.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        hs1.alignment = .center
        hs1.axis = .horizontal
        hs1.distribution = UIStackView.Distribution.equalSpacing
        return hs1
    }()

    var horizontalStack2: UIStackView = {
        let hs2 = UIStackView()
        hs2.axis = .horizontal
        hs2.isLayoutMarginsRelativeArrangement = true
        hs2.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        hs2.distribution = UIStackView.Distribution.equalSpacing
        hs2.alignment = .center
        return hs2
    }()

    var stackSeparator1: UIStackView = {
        let ss1 = UIStackView()
        ss1.axis = .horizontal
        ss1.isLayoutMarginsRelativeArrangement = true
        ss1.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        ss1.distribution = UIStackView.Distribution.equalSpacing
        ss1.alignment = .center
        return ss1
    }()

    var stackSeparator2: UIStackView = {
        let ss2 = UIStackView()
        ss2.axis = .horizontal
        ss2.isLayoutMarginsRelativeArrangement = true
        ss2.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        ss2.distribution = UIStackView.Distribution.equalSpacing
        ss2.alignment = .center
        return ss2
    }()

    var verticalStack: UIStackView = {
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
        hstack.alignment = .center
        hstack.distribution = .equalCentering
        return hstack
    }()

    var stackWithDateAndDeadline: UIStackView = {
        let swdad = UIStackView()
        swdad.axis = .vertical
        swdad.distribution = .fill
        swdad.spacing = 0
        return swdad
    }()

    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        return separator
    }()

    let separator1: UIView = {
        let separator1 = UIView()
        separator1.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        return separator1
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInset = .zero
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    var flagCalendar = true

    let calendarView: UICalendarView = {
        var calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.calendar.firstWeekday = 2
        calendarView.availableDateRange = DateInterval.init(start: .now, end: Date.distantFuture)
        calendarView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return calendarView
    }()

    let switchButton: UISwitch = {
        let switchButton = UISwitch()
        return switchButton
    }()

    var imageImportant: UIImage {
        let imageImportant = UIImage(named: "imp")?.withRenderingMode(.alwaysOriginal)
        return imageImportant!
    }

    var imageLow: UIImage {
        let imageLow = UIImage(named: "low")?.withRenderingMode(.alwaysOriginal)
        return imageLow!
    }

    let labelDate: UILabel = {
        let labelDate = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        labelDate.frame = labelFrame
        labelDate.font = UIFont(name: "HelveticaNeue", size: 15)
        labelDate.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        return labelDate
    }()

    let labelImportance: UILabel = {
        let labelImportance = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        labelImportance.frame = labelFrame
        labelImportance.text = "Важность"
        labelImportance.font = UIFont(name: "HelveticaNeue", size: 17)
        labelImportance.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return labelImportance
    }()

    let labelDeadline: UILabel = {
        let labelDeadline = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        labelDeadline.frame = labelFrame
        labelDeadline.text = "Сделать до"
        labelDeadline.font = UIFont(name: "HelveticaNeue", size: 17)
        labelDeadline.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return labelDeadline
    }()

    let labelTask: UILabel = {
        let labelTask = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        labelTask.frame = labelFrame
        labelTask.text = "Дело"
        labelTask.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        labelTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return labelTask
    }()

    let saveTask: UILabel = {
        let saveTask = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        saveTask.frame = labelFrame
        saveTask.text = "Сохранить"
        saveTask.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        saveTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        return saveTask
    }()

    let cancelTask: UIButton = {
        let cancelTask = UIButton(type: .system)
        cancelTask.setTitle("Отменить", for: .normal)
        cancelTask.frame = CGRect(x: 0, y: 0, width: 100, height: 23)
        cancelTask.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        return cancelTask
    }()

    var textView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(origin: CGPoint(), size: CGSize(width: 330, height: 120))
        textView.font = UIFont(name: "HelveticaNeue", size: 17)
        textView.text = "Что надо сделать?"
        textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.layer.cornerRadius = 16
        textView.textContainer.lineFragmentPadding = 17
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        textView.returnKeyType = .done
        return textView
    }()

    let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.layer.cornerRadius = 16
        deleteButton.frame.size.height = 56
        deleteButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        deleteButton.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return deleteButton
    }()

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()

    @IBAction func dismissModalView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func hideKeyboard() {
        if textView.isFirstResponder {
            view.endEditing(true)
        }
    }
}
