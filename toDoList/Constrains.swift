//
//  constrains.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    func setupConstrains() {
        NSLayoutConstraint.activate([

            horizontalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            horizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 35),

            verticalStack1.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalStack1.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            verticalStack1.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            verticalStack1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            verticalStack1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            horizontalStack1.heightAnchor.constraint(equalToConstant: 54),
            horizontalStack1.trailingAnchor.constraint(equalTo: verticalStack1.trailingAnchor),

            horizontalStack2.heightAnchor.constraint(equalToConstant: 54),

            segmentControl.heightAnchor.constraint(equalToConstant: segmentControl.frame.height),
            segmentControl.widthAnchor.constraint(equalToConstant: segmentControl.frame.width),

            stackSeparator1.topAnchor.constraint(equalTo: horizontalStack1.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)

        ])
    }
}
