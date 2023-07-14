//
//  TableView.swift
//  toDoList
//
//  Created by Maria Slepneva on 30.06.2023.
//

import UIKit
import CocoaLumberjackSwift

extension ListOfTasksViewController: UITableViewDataSource, UITableViewDelegate {

    func strikeText(strike: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
        value: NSUnderlineStyle.single.rawValue,
        range: NSRange(location: 0, length: attributeString.length))

        return attributeString
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileCache.items.count
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let infoAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            completionHandler(true)
        }
        infoAction.image = UIImage(named: "info")
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            self.fileCache.deleteItemCoreData(deleteItem: self.fileCache.items[indexPath.row])
            self.fileCache.getAllItemsCoreData()
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "delete")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.beginUpdates()
            if var configuration = tableView.cellForRow(at: indexPath)?.defaultContentConfiguration() {
                configuration.textProperties.numberOfLines = 3
                let item = self.fileCache.items[indexPath.row]
                var newItem = self.fileCache.items[indexPath.row]
                newItem.isTaskComplete = !newItem.isTaskComplete
                self.fileCache.updateItemCoreData(newItem: newItem)
                configuration.text = item.text
                tableView.cellForRow(at: indexPath)?.accessoryView = self.imageEdit
                configuration.image = self.imageDone
                configuration.attributedText = NSAttributedString(
                    string: item.text,
                    attributes: [
                        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
                    ]
                )
                configuration.textProperties.color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
                tableView.cellForRow(at: indexPath)?.contentConfiguration = configuration
            }
            tableView.updateConstraints()
            tableView.endUpdates()
            completionHandler(true)
        }
        doneAction.backgroundColor = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0)
        doneAction.image = UIImage(named: "swipe_done")

        let configuration = UISwipeActionsConfiguration(actions: [doneAction])
        return configuration
    }

    @objc func handleLeftSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }

    @objc func handleRightSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGesture.direction = .left
        cell.addGestureRecognizer(leftSwipeGesture)

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        rightSwipeGesture.direction = .right
        cell.addGestureRecognizer(rightSwipeGesture)

        var configuration = cell.defaultContentConfiguration()

        configuration.textProperties.numberOfLines = 3
        let item = fileCache.items[indexPath.row]
        cell.accessoryView = imageEdit
        if item.isTaskComplete == true {
            configuration.image = imageDone
            configuration.attributedText = NSAttributedString(string: item.text, attributes:
            [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            configuration.textProperties.color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        } else if item.importance == .important {
            configuration.image = imageImportantIcon
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "imp")
            let attributedString = NSMutableAttributedString()
            let imageString = NSAttributedString(attachment: imageAttachment)
            let textString = NSAttributedString(string: item.text)
            let fontSize: CGFloat = 17.0
            attributedString.append(imageString)
            attributedString.append(textString)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize),
            range: NSRange(location: 0, length: attributedString.length))
            let font = UIFont(name: "Helvetica-Bold", size: fontSize)
            let imageBounds = CGRect(x: 0, y: -1, width: imageAttachment.image?.size.width ?? 0,
            height: imageAttachment.image?.size.height ?? 0)
            imageAttachment.bounds = imageBounds
            configuration.attributedText = attributedString
        } else if item.importance == .unimportant {
            configuration.image = imageLowAndUsualIcon
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "low")
            let attributedString = NSMutableAttributedString()
            let imageString = NSAttributedString(attachment: imageAttachment)
            let textString = NSAttributedString(string: item.text)
            let fontSize: CGFloat = 17.0
            attributedString.append(imageString)
            attributedString.append(textString)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize),
            range: NSRange(location: 0, length: attributedString.length))
            let font = UIFont(name: "Helvetica-Bold", size: fontSize)
            let imageBounds = CGRect(x: 0, y: 0, width: imageAttachment.image?.size.width ?? 0,
            height: imageAttachment.image?.size.height ?? 0)
            imageAttachment.bounds = imageBounds
            configuration.attributedText = attributedString
        } else {
            let attributedString = NSMutableAttributedString()
            configuration.text = item.text
            let textString = NSAttributedString(string: item.text)
            let fontSize: CGFloat = 17.0
            attributedString.append(textString)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize),
            range: NSRange(location: 0, length: attributedString.length))
            let font = UIFont(name: "Helvetica-Bold", size: fontSize)
            configuration.attributedText = attributedString
            configuration.image = imageLowAndUsualIcon
        }
        if let deadline = item.deadline {
            if item.isTaskComplete != true {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "calendar")
                let attributedString = NSMutableAttributedString()
                let imageString = NSAttributedString(attachment: imageAttachment)
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.dateFormat = "dd MMMM"
                let textString = NSAttributedString(string: formatter.string(from: deadline))
                let fontSize: CGFloat = 15.0
                attributedString.append(imageString)
                attributedString.append(textString)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize),
                                              range: NSRange(location: 0, length: attributedString.length))
                let font = UIFont(name: "Helvetica-Bold", size: fontSize)
                attributedString.addAttribute(
                    .foregroundColor,
                    value: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3),
                    range: NSRange(location: 0, length: attributedString.length)
                )
                let imageBounds = CGRect(x: 0, y: -3, width: imageAttachment.image?.size.width ?? 0,
                                         height: imageAttachment.image?.size.height ?? 0)
                imageAttachment.bounds = imageBounds
                configuration.secondaryAttributedText = attributedString
            }
        }
        cell.contentConfiguration = configuration
        cell.separatorInset = UIEdgeInsets(top: 0, left: 59.65, bottom: 0, right: 0)
        cell.sizeToFit()
        DDLogDebug(cell.frame.height)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 56)
        let newLabel = UILabel(frame: footerView.bounds)
        newLabel.text = "Новое"
        newLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        footerView.addSubview(newLabel)
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newLabel.topAnchor.constraint(equalTo: footerView.topAnchor),
            newLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 59),
            newLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            newLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modalVC = ViewController()
        modalVC.tappedCell = fileCache.items[indexPath.row]

        let item = fileCache.items[indexPath.row]
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
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }

}
