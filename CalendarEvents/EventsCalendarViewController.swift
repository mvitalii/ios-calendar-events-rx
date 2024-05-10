import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EventsCalendarViewController: UIViewController {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    lazy var calendarView: CalendarView = { CalendarView() }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()

    lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(systemItem: .add)
        addButton.tintColor = UIColor.black
        return addButton
    }()

    private let viewModel: EventsCalendarViewModel
    private let calendarController: EventsCalendarController
    private let disposeBag = DisposeBag()

    var didTapAddEvent: ((Date) -> Void)?
    var didTapChangeEvent: ((EventModel) -> Void)?
    
    init(service: EventService = LocalEventService.shared) {
        viewModel = EventsCalendarViewModel(service: service)
        calendarController = EventsCalendarController(service: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()

        viewModel.loadEvents()
    }

    func setupUI() {
        view.backgroundColor = .white
        title = "Events Calendar"
        navigationItem.rightBarButtonItem = addButton

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view).offset(20)
            make.centerX.equalTo(self.view)
        }

        stackView.addArrangedSubview(calendarView)
        stackView.addArrangedSubview(tableView)

        setupCalendar()
        setupTableView()
    }

    func setupCalendar() {
        calendarView.setDelegate(calendarController)

        calendarView.snp.makeConstraints { make in
            make.height.equalTo(self.calendarView.snp.width)
        }

        calendarView.makeConstrants()
        calendarView.setupCalendar()
    }

    func setupTableView() {
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
    }

    func bindViewModel() {
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let selectedDate = self?.calendarView.selectedDate else { return }
                self?.didTapAddEvent?(selectedDate)
            })
            .disposed(by: disposeBag)

        viewModel.events
            .do(onNext: { [weak self] _ in
                self?.calendarView.reloadCalendar()
            })
            .bind(to: tableView.rx.items(
                cellIdentifier: "EventCell",
                cellType: EventCell.self)) { _, item, cell in
                    cell.configure(event: item)
                }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.viewModel.selectEvent(at: indexPath)
            })
            .disposed(by: disposeBag)

        viewModel.editRelay
            .subscribe(onNext: { [weak self] event in
                guard let event = event else { return }
                self?.didTapChangeEvent?(event)
            })
            .disposed(by: disposeBag)
    }
}
