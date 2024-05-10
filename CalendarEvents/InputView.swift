import UIKit

class InputView: UIView {

    let title: String
    let placeholder: String

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = title
        return label
    }()

    lazy var textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGroupedBackground
        view.layer.cornerRadius = 10
        return view
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = placeholder
        return textField
    }()

    init(title: String, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        stackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints{ $0.height.equalTo(16) }

        textFieldView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.left.equalTo(self.textFieldView).offset(10)
            $0.centerX.equalTo(self.textFieldView)
            $0.centerY.equalTo(self.textFieldView)
        }

        stackView.addArrangedSubview(textFieldView)
        textFieldView.snp.makeConstraints { $0.height.equalTo(40) }
    }

}
