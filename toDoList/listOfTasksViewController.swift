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

class ListOfTasksViewController: UIViewController {

    let context: AppDelegate? = nil

    static let deviceID = UIDevice.current.identifierForVendor!.uuidString

    weak var delegate: ListOfTasksViewControllerDelegate?

    let networking = DefaultNetworkingService(token: "octactine")

    let countOfDoneTasks = 0

    let doneTasks: UILabel = {
        let doneTasks = UILabel()
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 23)
        doneTasks.frame = labelFrame
        doneTasks.font = UIFont(name: "HelveticaNeue", size: 15)
        doneTasks.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        return doneTasks
    }()

    var imageImportant: UIImage {
        let imageImportant = UIImage(named: "imp")?.withRenderingMode(.alwaysOriginal)
        return imageImportant!
    }

    var imageLow: UIImage {
        let imageLow = UIImage(named: "low")?.withRenderingMode(.alwaysOriginal)
        return imageLow!
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
        let imagePlus = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        return imagePlus!
    }

    var imageLowAndUsualIcon: UIImage {
        let imageLowAndUsualIcon = UIImage(named: "low and usual")?.withRenderingMode(.alwaysOriginal)
        return imageLowAndUsualIcon!
    }

    var imageImportantIcon: UIImage {
        let imageImportantIcon = UIImage(named: "important")?.withRenderingMode(.alwaysOriginal)
        return imageImportantIcon!
    }

    var imageDone: UIImage {
        let imageDone = UIImage(named: "done")?.withRenderingMode(.alwaysOriginal)
        return imageDone!
    }

    var imageEdit: UIImageView {
        let imageEdit = UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal)
        let image = UIImageView(image: imageEdit)
        return image
    }

    var contentHeight = CGFloat()

    let tableView = UITableView(frame: .zero, style: .plain)
    var fileCache = FileCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fileCache.setContext(context: context)
        }
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        fileCache.getAllItemsCoreData()
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
        view.addSubview(buttonPlus)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension // автоматически рассчитывает высоту ячейки
        tableView.estimatedRowHeight = 50.0 // примерное значение высоты ячейки (может быть любым)

        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            doneAndShowStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            doneAndShowStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            doneAndShowStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18),
            doneAndShowStack.heightAnchor.constraint(equalToConstant: 16),
            tableView.topAnchor.constraint(equalTo: doneAndShowStack.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(fileCache.items.count + 1) * 98),
            buttonPlus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonPlus.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        tableView.reloadData()
    }
}
