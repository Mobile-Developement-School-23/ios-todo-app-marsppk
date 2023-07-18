//
//  TableView.swift
//  toDoList
//
//  Created by Maria Slepneva on 30.06.2023.
//

import UIKit
import CocoaLumberjackSwift

extension ListOfTasksViewController: CustomCellDelegate, UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = doneButton.titleLabel?.text == "Скрыть" ?
        fileCache.items.count :
        fileCacheWithoutDone.items.count
        updateFooterView(for: tableView, sectionIndex: section, cellCount: cellCount)
        return cellCount
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius = 16
        var corners: UIRectCorner = []

        if indexPath.row == 0 {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
        cell.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { fatalError() }

        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        swipeGestureRecognizer.direction = .left
        cell.addGestureRecognizer(swipeGestureRecognizer)

        let swipeGestureRecognizer1 = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        swipeGestureRecognizer1.direction = .right
        cell.addGestureRecognizer(swipeGestureRecognizer1)

        var data = fileCache
        if doneButton.titleLabel?.text == "Показать" {
            data = fileCacheWithoutDone
        }
        cell.deadline.attributedText = nil
        cell.contentStack.removeArrangedSubview(cell.deadline)
        cell.contentView.isUserInteractionEnabled = false
        cell.myLabel.font = UIFont(name: "Helvetica Neue", size: 17)
        cell.layoutMargins = UIEdgeInsets.zero
        cell.layer.mask = nil
        cell.delegate = self
        let isDone = data.items[indexPath.row].isTaskComplete
        let importance = data.items[indexPath.row].importance
        let deadline = data.items[indexPath.row].deadline
        let firstTitle = importance != .important ? "low and usual" : "important"
        let title = isDone ? "done" : firstTitle
        cell.buttonComplete.setImage(UIImage(named: title), for: .normal)
        if isDone {
            let attributedText = NSMutableAttributedString(string: data.items[indexPath.row].text)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributedText.length))
            attributedText.addAttribute(
                .foregroundColor,
                value: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3),
                range: NSRange(location: 0, length: attributedText.length)
            )
            cell.myLabel.attributedText = attributedText
        } else {
            let attributedText = NSMutableAttributedString()
            attributedText.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: attributedText.length))
            let textString = NSAttributedString(string: data.items[indexPath.row].text)
            if importance != .usual {
                let title = importance == .unimportant ? "low" : "imp"
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: title)
                imageAttachment.bounds = CGRect(x: 0, y: -1, width: imageAttachment.image?.size.width ?? 0, height: imageAttachment.image?.size.height ?? 0)
                let imageString = NSAttributedString(attachment: imageAttachment)
                attributedText.append(imageString)
                attributedText.append(NSAttributedString(" "))
            }
            attributedText.append(textString)
            cell.myLabel.attributedText = attributedText
            if let deadline = deadline {
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
                attributedText.append(NSAttributedString(" "))
                attributedString.append(textString)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize),
                                              range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(
                    .foregroundColor,
                    value: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3),
                    range: NSRange(location: 0, length: attributedString.length)
                )
                let imageBounds = CGRect(x: 0, y: -2.5, width: imageAttachment.image?.size.width ?? 0,
                                         height: imageAttachment.image?.size.height ?? 0)
                imageAttachment.bounds = imageBounds
                cell.deadline.attributedText = attributedString
                cell.contentStack.addArrangedSubview(cell.deadline)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let infoAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                self.didTapButton1(cell: cell)
                completionHandler(true)
            }
        }
        infoAction.image = UIImage(named: "info")
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            var data = self.fileCache
            if self.doneButton.titleLabel?.text == "Показать" {
                data = self.fileCacheWithoutDone
            }
            self.fileCache.deleteItemCoreData(deleteItem: data.items[indexPath.row])
            self.fileCache.getAllItemsCoreData()
            self.updateArrayWithoutDone()
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "delete")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            var data = self.fileCache
            if self.doneButton.titleLabel?.text == "Показать" {
                data = self.fileCacheWithoutDone
            }
            var newItem = data.items[indexPath.row]
            newItem.isTaskComplete = !newItem.isTaskComplete
            self.fileCache.updateItemCoreData(newItem: newItem)
            self.fileCache.getAllItemsCoreData()
            self.updateArrayWithoutDone()
            tableView.reloadData()
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
}
