//
//  ViewController.swift
//  toDoList
//
//  Created by Maria Slepneva on 12.06.2023.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    var fileCache = FileCache()
    
    var toDoitem1: TodoItem = TodoItem(id: UUID().uuidString, text: "", deadline: nil, importance: .usual, isTaskComplete: false, dateOfCreation: Date(), dateOfChange: nil)
    
    var importance = 0
    
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
        let s = UIView()
        s.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        return s
    }()
    
    let separator1: UIView = {
        let s1 = UIView()
        s1.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        return s1
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        sv.contentInset = .zero
        sv.alwaysBounceVertical = true
        sv.isScrollEnabled = true
        return sv
    }()
    
    var flag_calendar = true
    
    let calendarView: UICalendarView = {
        var cv = UICalendarView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.calendar = .current
        cv.locale = .current
        cv.fontDesign = .rounded
        cv.calendar.firstWeekday = 2
        cv.availableDateRange = DateInterval.init(start: .now, end: Date.distantFuture)
        cv.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return cv
    }()
    
    let Switch: UISwitch = {
        let s = UISwitch()
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
        tv.returnKeyType = .done
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
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "dd MMMM yyyy"
        return f
    }()
}
