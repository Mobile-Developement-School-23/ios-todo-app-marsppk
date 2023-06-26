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
}
