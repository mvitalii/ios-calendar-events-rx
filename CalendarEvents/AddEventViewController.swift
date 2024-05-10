import UIKit
import RxSwift
import RxCocoa

class AddEventViewController: UIViewController {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    lazy var dateTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    lazy var nameView: InputView = { InputView(title: "Event Title", placeholder: "Enter title") }()
    lazy var dateView: InputView = { InputView(title: "Date", placeholder: "Date") }()
    lazy var timeView: InputView = { InputView(title: "Time", placeholder: "10:00 AM") }()

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    lazy var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        return toolbar
    }()

    lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(systemItem: .add)
        addButton.tintColor = UIColor.black
        return addButton
    }()

    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()

    lazy var doneButton: UIBarButtonItem = {
        let doneButton = UIBarButtonItem(systemItem: .done)
        doneButton.tintColor = UIColor.black
        return doneButton
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()

    private let viewModel: AddEventViewModel
    private let disposeBag = DisposeBag()

    var addEventHandler: ((EventModel) -> Void)?
    var editEventHandler: ((EventModel) -> Void)?

    init(date: Date) {
        viewModel = AddEventViewModel(selectedDate: date)
        super.init(nibName: nil, bundle: nil)
    }

    init(event: EventModel) {
        viewModel = AddEventViewModel(event: event)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    func setupUI() {
        view.backgroundColor = .white
        title = viewModel.title

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = viewModel.eventTitle.value.isEmpty
            ? addButton
            : UIBarButtonItem(customView: editButton)

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view).offset(20)
            make.centerX.equalTo(self.view)
        }

        stackView.addArrangedSubview(nameView)
        stackView.addArrangedSubview(dateTimeStackView)

        dateTimeStackView.addArrangedSubview(dateView)
        dateTimeStackView.addArrangedSubview(timeView)

        pickerToolbar.setItems([doneButton], animated: false)

        dateView.textField.inputView = datePicker
        dateView.textField.inputAccessoryView = pickerToolbar

        timeView.textField.inputView = timePicker
        timeView.textField.inputAccessoryView = pickerToolbar

        nameView.textField.text = viewModel.eventTitle.value
        dateView.textField.text = Helpers.stringDateFrom(viewModel.selectedDate)
        timeView.textField.text = Helpers.stringTimeFrom(viewModel.selectedDate)
    }

    func bindViewModel() {
        nameView.textField.rx.text.orEmpty
            .bind(to: viewModel.eventTitle)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.addEvent()
            })
            .disposed(by: disposeBag)

        editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.editEvent()
            })
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        viewModel.isValid
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)

        datePicker.rx.date
            .skip(1)
            .subscribe(onNext: { [weak self] date in
                self?.dateView.textField.text = Helpers.stringDateFrom(date)
                self?.viewModel.updateDate(date)
            })
            .disposed(by: disposeBag)

        timePicker.rx.date
            .skip(1)
            .subscribe(onNext: { [weak self] date in
                self?.timeView.textField.text = Helpers.stringTimeFrom(date)
                self?.viewModel.updateTime(date)
            })
            .disposed(by: disposeBag)

        viewModel.saveRelay
            .subscribe(onNext: { [weak self] event in
                guard let event = event else { return }
                self?.addEventHandler?(event)
            })
            .disposed(by: disposeBag)

        viewModel.editRelay
            .subscribe(onNext: { [weak self] event in
                guard let event = event else { return }
                self?.editEventHandler?(event)
            })
            .disposed(by: disposeBag)
    }
}
