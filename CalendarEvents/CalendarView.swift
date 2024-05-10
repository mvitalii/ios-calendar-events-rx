import UIKit
import FSCalendar

class CalendarView: UIView {

    var calendar: FSCalendar
    var selectedDate: Date? { calendar.selectedDate }

    override init(frame: CGRect) {
        let calendar = FSCalendar(frame: .zero)
        calendar.firstWeekday = 2
        self.calendar = calendar
        super.init(frame: frame)
        layer.cornerRadius = 10
        addSubview(calendar)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDelegate(_ delegate: FSCalendarDelegate) {
        calendar.delegate = delegate
    }

    func reloadCalendar() {
        calendar.reloadData()
    }

    func makeConstrants() {
        calendar.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    func setupCalendar() {
        let appearance = calendar.appearance

        appearance.headerTitleFont = UIFont.systemFont(ofSize: 15)
        appearance.headerDateFormat = "MMMM yyyy"
        appearance.headerMinimumDissolvedAlpha = 0
        appearance.todayColor = UIColor.black

        
        let leftArrowButton = makeArrowButton("arrow.backward", tintColor: appearance.headerTitleColor)
        let rightArrowButton = makeArrowButton("arrow.forward", tintColor: appearance.headerTitleColor)

        leftArrowButton.addTarget(self, action: #selector(showPrevMonth), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(showNextMonth), for: .touchUpInside)

        addSubview(leftArrowButton)
        addSubview(rightArrowButton)

        leftArrowButton.snp.updateConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.centerY.equalTo(self.calendar.calendarHeaderView.snp.centerY)
            $0.left.equalTo(self.calendar.calendarHeaderView.snp.left)
        }
        rightArrowButton.snp.updateConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.centerY.equalTo(self.calendar.calendarHeaderView.snp.centerY)
            $0.right.equalTo(self.calendar.calendarHeaderView.snp.right)
        }
    }

    func makeArrowButton(_ sfName: String, tintColor: UIColor) -> UIButton {
        let arrowButton = UIButton()
        arrowButton.setImage(UIImage(systemName: sfName), for: .normal)
        arrowButton.tintColor = tintColor
        return arrowButton
    }

    @objc func showPrevMonth() {
        let currentPage = calendar.currentPage
        guard let prevMonth = calendar.gregorian.date(byAdding: .month, value: -1, to: currentPage) else { return }
        calendar.setCurrentPage(prevMonth, animated: true)
    }

    @objc func showNextMonth() {
        let currentPage = calendar.currentPage
        guard let nextMonth = calendar.gregorian.date(byAdding: .month, value: 1, to: currentPage) else { return }
        calendar.setCurrentPage(nextMonth, animated: true)
    }
}
