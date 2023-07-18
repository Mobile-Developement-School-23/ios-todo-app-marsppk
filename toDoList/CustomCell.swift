import Foundation
import UIKit

protocol CustomCellDelegate: class {
    func didTapButton(cell: TableViewCell)
    func didTapButton1(cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"

    weak var delegate: CustomCellDelegate?

    public let myLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = .systemFont(ofSize: 17)
        myLabel.textColor = .label
        myLabel.numberOfLines = 3
        return myLabel
    }()

    public let contentStack: UIStackView = {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.distribution = .equalSpacing
        contentStack.alignment = .leading
        return contentStack
    }()

    public var deadline: UILabel = {
        let myLabel = UILabel()
        myLabel.font = .systemFont(ofSize: 17)
        myLabel.textColor = .label
        return myLabel
    }()

    public let buttonComplete: UIButton = {
        let buttonComplete = UIButton()
        buttonComplete.isUserInteractionEnabled = true
        return buttonComplete
    }()

    public let buttonEdit: UIButton = {
        let buttonComplete = UIButton()
        buttonComplete.setImage(UIImage(named: "edit"), for: .normal)
        buttonComplete.isUserInteractionEnabled = true
        return buttonComplete
    }()

    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton(cell: self)
    }

    @IBAction func buttonTapped1(_ sender: UIButton) {
        delegate?.didTapButton1(cell: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        layer.cornerRadius = 16
        contentView.backgroundColor = .white
      }

    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(buttonComplete)
        self.addSubview(contentStack)
        self.addSubview(buttonEdit)
        self.selectionStyle = .none

        buttonComplete.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        buttonEdit.addTarget(self, action: #selector(buttonTapped1(_:)), for: .touchUpInside)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        buttonComplete.translatesAutoresizingMaskIntoConstraints = false
        buttonEdit.translatesAutoresizingMaskIntoConstraints = false

        contentStack.addArrangedSubview(myLabel)

        NSLayoutConstraint.activate([
            self.buttonComplete.topAnchor.constraint(equalTo: self.topAnchor, constant: 17.5),
            self.buttonComplete.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17.5),
            self.buttonComplete.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.buttonComplete.widthAnchor.constraint(equalToConstant: 24),

            self.buttonEdit.topAnchor.constraint(equalTo: self.topAnchor, constant: 17.5),
            self.buttonEdit.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17.5),
            self.buttonEdit.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.buttonEdit.widthAnchor.constraint(equalToConstant: 11.9),

            self.contentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 17.5),
            self.contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17.5),
            self.contentStack.leadingAnchor.constraint(equalTo: buttonComplete.trailingAnchor, constant: 12),
            self.contentStack.trailingAnchor.constraint(equalTo: buttonEdit.leadingAnchor, constant: -16)
        ])
    }
}
