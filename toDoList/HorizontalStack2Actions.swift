//
//  horizontalStack2Actions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    func setupHorizontalStack2() -> UIStackView {
        let horizontalStack2 = UIStackView()
        horizontalStack2.axis = .horizontal
        horizontalStack2.distribution = UIStackView.Distribution.equalSpacing
        horizontalStack2.alignment = .center
        [labelDeadline, Switch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack2.addArrangedSubview($0)
        }
        horizontalStack2.translatesAutoresizingMaskIntoConstraints = false
        return horizontalStack2
    }
}
