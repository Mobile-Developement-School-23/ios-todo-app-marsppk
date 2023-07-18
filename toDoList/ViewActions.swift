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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        background()
        orientation()

        textView.delegate = self
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fileCache.setContext(context: context)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped1))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissModalView))
        self.hideKeyboardWhenTappedAround()
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        saveTask.isUserInteractionEnabled = true
        labelDate.isUserInteractionEnabled = true
        saveTask.addGestureRecognizer(tapGesture)
        labelDate.addGestureRecognizer(tapGesture1)
        cancelTask.addGestureRecognizer(tapGesture2)
        stackSeparator1.addArrangedSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false

        setImages()

        [labelImportance, segmentControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack1.addArrangedSubview($0)
        }

        [labelDeadline, labelDate].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackWithDateAndDeadline.addArrangedSubview($0)
        }

        [stackWithDateAndDeadline, switchButton].forEach {
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
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
