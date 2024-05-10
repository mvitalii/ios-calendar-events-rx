import UIKit

class EventCell: UITableViewCell {
    static let reuseIdentifier = "EventCell"

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGroupedBackground
        view.layer.cornerRadius = 10
        return view
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray
        return label
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        backgroundColor = UIColor.clear
        selectionStyle = .none

        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(50)
        }

        containerView.addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)

        stackView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalTo(containerView)
        }

        containerView.addSubview(timeLabel)

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
        }

        timeLabel.snp.makeConstraints { make in
            make.right.equalTo(containerView).offset(-10)
            make.centerY.equalTo(containerView)
        }
    }

    func configure(event: EventModel) {
        titleLabel.text = event.title
        dateLabel.text = Helpers.stringDateFrom(event.date)
        timeLabel.text = Helpers.stringTimeFrom(event.date)
    }
}
