//
//  CustomCell.swift
//  toDoList
//
//  Created by Maria Slepneva on 13.07.2023.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"

    public let myLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = .systemFont(ofSize: 18)
        myLabel.textColor = .label
        myLabel.numberOfLines = 3
        return myLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.myLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.myLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.myLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.myLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
