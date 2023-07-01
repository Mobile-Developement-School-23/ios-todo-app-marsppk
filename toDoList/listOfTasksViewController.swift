//
//  ViewController1.swift
//  toDoList
//
//  Created by Maria Slepneva on 27.06.2023.
//

import UIKit
import CocoaLumberjackSwift

protocol ListOfTasksViewControllerDelegate: class {
      func load(item: TodoItem)
  }

class ListOfTasksViewController: UIViewController {

    weak var delegate: ListOfTasksViewControllerDelegate?

    let countOfDoneTasks = 0

    let doneTasks: UILabel = {
        let st = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        st.frame = labelFrame
        st.font = UIFont(name: "HelveticaNeue", size: 15)
        st.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        return st
    }()

    var imageImportant: UIImage {
        let ii = UIImage(named: "imp")?.withRenderingMode(.alwaysOriginal)
        return ii!
    }

    var imageLow: UIImage {
        let il = UIImage(named: "low")?.withRenderingMode(.alwaysOriginal)
        return il!
    }

    let showButton: UIButton = {
        let showButton = UIButton(type: .system)
        showButton.setTitle("Показать", for: .normal)
        showButton.frame = CGRect(x: 0, y: 0, width: 100, height: 23)
        return showButton
    }()

    let doneAndShowStack: UIStackView = {
        let doneAndShowStack = UIStackView()
        doneAndShowStack.axis = .horizontal
        doneAndShowStack.alignment = .center
        doneAndShowStack.translatesAutoresizingMaskIntoConstraints = false
        doneAndShowStack.distribution = .equalSpacing
        return doneAndShowStack
    }()

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
        let ip = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        return ip!
    }

    var imageLowAndUsualIcon: UIImage {
        let ip = UIImage(named: "low and usual")?.withRenderingMode(.alwaysOriginal)
        return ip!
    }

    var imageImportantIcon: UIImage {
        let ip = UIImage(named: "important")?.withRenderingMode(.alwaysOriginal)
        return ip!
    }

    var imageDone: UIImage {
        let ip = UIImage(named: "done")?.withRenderingMode(.alwaysOriginal)
        return ip!
    }

    var imageEdit: UIImageView {
        let ip = UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal)
        let image = UIImageView(image: ip)
        return image
    }

    var contentHeight = CGFloat()

    func calculateTableViewHeight() {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.layoutIfNeeded()
        contentHeight = tableView.contentSize.height
        DDLogDebug(contentHeight)
        tableView.heightAnchor.constraint(equalToConstant: contentHeight + 1000).isActive = true
    }

    var fileCache = FileCache()

    let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        fileCache.loadAll(name: "test1.json")
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)]

        buttonPlus.setImage(imagePlus, for: .normal)
        buttonPlus.addTarget(self, action: #selector(openModalScreen), for: .touchUpInside)

        doneTasks.text = "Выполнено — " + String(countOfDoneTasks)

        [doneTasks, showButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            doneAndShowStack.addArrangedSubview($0)
        }

        scrollView.addSubview(doneAndShowStack)
        scrollView.addSubview(tableView)
        view.addSubview(scrollView)
        view.addSubview(buttonPlus)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56 // Оценочная высота ячейки
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false

        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            doneAndShowStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            doneAndShowStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            doneAndShowStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            doneAndShowStack.heightAnchor.constraint(equalToConstant: 16),
            tableView.topAnchor.constraint(equalTo: doneAndShowStack.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            buttonPlus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonPlus.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculateTableViewHeight()
    }

    @IBAction func openModalScreen(_ sender: Any) {
        let modalVC = ViewController()
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }

}

extension ListOfTasksViewController: ViewControllerDelegate {
    func didSaveNote(_ data: TodoItem) {
        fileCache.add(item: data)
        fileCache.saveAll(name: "test1.json")
        tableView.reloadData()
        calculateTableViewHeight()
    }
}
