import FSCalendar

class EventsCalendarController: NSObject, FSCalendarDelegateAppearance {

    private let service: EventService

    init(service: EventService) {
        self.service = service
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if Helpers.isToday(date: date) {
            return UIColor.white
        }
        if Helpers.containsDate(date: date, in: service.eventsValue.map { $0.date }) {
            return calendar.appearance.headerTitleColor
        }
        if Helpers.isWeekend(date: date) {
            return calendar.appearance.titlePlaceholderColor
        }
        return nil
    }
}
