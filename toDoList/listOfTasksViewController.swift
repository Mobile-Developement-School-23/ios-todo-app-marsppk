//
//  ListOfTasksViewController.swift
//  toDoList
//
//  Created by Maria Slepneva on 27.06.2023.
//

import UIKit
import CocoaLumberjackSwift

protocol ListOfTasksViewControllerDelegate: AnyObject {
      func load(item: TodoItem)
  }

class ListOfTasksViewController: UIViewController, UITextViewDelegate {

    let context: AppDelegate? = nil

    static let deviceID = UIDevice.current.identifierForVendor!.uuidString

    weak var delegate: ListOfTasksViewControllerDelegate?

    let networking = DefaultNetworkingService(token: "octactine")

    let countOfDoneTasks = 0

    let buttonPlus: UIButton = {
        let buttonPlus = UIButton(type: .system)
        buttonPlus.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        buttonPlus.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        buttonPlus.layer.shadowOpacity = 0.3
        buttonPlus.layer.shadowRadius = 10
        buttonPlus.translatesAutoresizingMaskIntoConstraints = false
        return buttonPlus
    }()

    var imagePlus: UIImage {
        let imagePlus = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        return imagePlus!
    }

    static var count = 0

    var isShown = true

    let doneButton = UIButton(type: .system)

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        return label
    }()

    var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "HelveticaNeue", size: 17)
        textView.text = "Новое"
        textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.layer.cornerRadius = 16
        textView.textContainer.lineFragmentPadding = 17
        textView.returnKeyType = .done
        textView.textContainerInset = UIEdgeInsets(top: 17.5, left: 36, bottom: 17.5, right: 20)
        return textView
    }()

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Новое" {
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
        if textView.text != "" {
            let item = TodoItem(id: nil, text: textView.text, deadline: nil, importance: .usual, isTaskComplete: false, dateOfCreation: Date(), dateOfChange: nil)
            textView.text = "Новое"
            textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            textView.font = UIFont(name: "HelveticaNeue", size: 17)
            fileCache.createItemCoreData(item: item)
            fileCache.getAllItemsCoreData()
            updateArrayWithoutDone()
            tableView.reloadData()
        }
        textView.text = "Новое"
        textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        textView.font = UIFont(name: "HelveticaNeue", size: 17)
        textView.frame.size = CGSize(width: textView.frame.width, height: 56)
    }

    func textViewDidChange(_ textView: UITextView) {
        textView.invalidateIntrinsicContentSize()
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: textView.frame.width, height: newSize.height)
    }

    func updateFooterView(for tableView: UITableView, sectionIndex: Int, cellCount: Int) {
        if cellCount == 0 {
            let cornerRadius: CGFloat = 16
            tableView.tableFooterView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
            tableView.tableFooterView?.layer.cornerRadius = cornerRadius
        } else {
            let cornerRadius: CGFloat = 16
            tableView.tableFooterView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            tableView.tableFooterView?.layer.cornerRadius = cornerRadius
        }
    }

    func updateCount() {
        ListOfTasksViewController.count = 0
        for item in fileCache.items {
            if item.isTaskComplete {
                ListOfTasksViewController.count += 1
            }
        }
        label.text = "Выполнено — \(ListOfTasksViewController.count)"
    }

    func updateArrayWithoutDone() {
        for item in fileCacheWithoutDone.items {
            fileCacheWithoutDone.remove(id: item.id)
        }
        for item in fileCache.items {
            if !item.isTaskComplete {
                fileCacheWithoutDone.add(item: item)
            }
        }
    }

    func didTapButton1(cell: TableViewCell) {
        var data = fileCache
        if doneButton.titleLabel?.text == "Показать" {
            data = fileCacheWithoutDone
        }
        let modalVC = ViewController()
        if let indexPath = tableView.indexPath(for: cell) {
            modalVC.tappedCell = data.items[indexPath.row]

            let item = data.items[indexPath.row]
            if item.text != "" {
                modalVC.textView.text = item.text
                modalVC.deleteButton.setTitleColor(UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0), for: .normal)
                modalVC.textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            if item.importance == .unimportant {
                modalVC.segmentControl.selectedSegmentIndex = 0
                modalVC.importance = -1
            }
            if item.importance == .usual {
                modalVC.segmentControl.selectedSegmentIndex = 1
                modalVC.importance = 0
            }
            if item.importance == .important {
                modalVC.segmentControl.selectedSegmentIndex = 2
                modalVC.importance = 1
            }
            if item.deadline != nil {
                modalVC.switchButton.isOn = true
                let stringDate = modalVC.formatter.string(from: item.deadline!)
                modalVC.labelDate.text = stringDate
                modalVC.stackWithDateAndDeadline.addArrangedSubview(modalVC.labelDate)
            }
            modalVC.isTaskComplete = item.isTaskComplete
            fileCache.updateItemCoreData(newItem: fileCache.items[indexPath.row])
            updateArrayWithoutDone()
            modalVC.delegate = self
            present(modalVC, animated: true, completion: nil)
        }
    }

    func didTapButton(cell: TableViewCell) {
        var data = fileCache
        if doneButton.titleLabel?.text == "Показать" {
            data = fileCacheWithoutDone
        }
        if let indexPath = tableView.indexPath(for: cell) {
            var newItem = data.items[indexPath.row]
            let isDone = !data.items[indexPath.row].isTaskComplete
            newItem.isTaskComplete = isDone
            fileCache.updateItemCoreData(newItem: newItem)
            fileCache.getAllItemsCoreData()
            updateArrayWithoutDone()
            updateCount()
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func orientationDidChange() {
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        tableView.reloadData()
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let title = isShown == true ? "Скрыть" : "Показать"
        UIView.performWithoutAnimation {
            doneButton.setTitle(title, for: .normal)
            doneButton.layoutIfNeeded()
        }
        isShown = !isShown
        tableView.reloadData()
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            TableViewCell.self,
            forCellReuseIdentifier: TableViewCell.identifier
        )
        return tableView
    }()

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    var fileCache = FileCache()

    var fileCacheWithoutDone = FileCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fileCache.setContext(context: context)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        fileCache.getAllItemsCoreData()
        updateArrayWithoutDone()

        updateCount()

        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)

        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)]

        textView.delegate = self
        textView.frame = CGRect(origin: CGPoint(), size: CGSize(width: tableView.frame.height, height: 56))
        buttonPlus.setImage(imagePlus, for: .normal)
        buttonPlus.addTarget(self, action: #selector(openModalScreen), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        let headerView = UIStackView()
        headerView.axis = .horizontal
        headerView.spacing = 32
        headerView.alignment = .center
        headerView.distribution = .equalSpacing
        headerView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)

        doneButton.setTitle("Показать", for: .normal)
        doneButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        headerView.addArrangedSubview(label)
        headerView.addArrangedSubview(doneButton)

        tableView.tableHeaderView = headerView

        let footerView = textView

        tableView.tableFooterView = textView

        footerView.layer.masksToBounds = true

        view.addSubview(tableView)
        view.addSubview(buttonPlus)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            headerView.topAnchor.constraint(equalTo: tableView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16),
            headerView.heightAnchor.constraint(equalToConstant: 40),
            headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor, constant: -32),

            buttonPlus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonPlus.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func openModalScreen(_ sender: Any) {
        let modalVC = ViewController()
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }

}

extension ListOfTasksViewController: ViewControllerDelegate {
    func didSaveNote() {
        fileCache.getAllItemsCoreData()
        updateArrayWithoutDone()
        tableView.reloadData()
    }
}
