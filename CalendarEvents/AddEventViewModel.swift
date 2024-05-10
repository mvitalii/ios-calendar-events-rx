import Foundation
import RxSwift
import RxCocoa

class AddEventViewModel {

    let title: String

    var eventTitle = BehaviorRelay<String>(value: "")
    var isValid: Observable<Bool> { eventTitle.asObservable().map { !$0.isEmpty } }

    var saveRelay = BehaviorRelay<EventModel?>(value: nil)
    var editRelay = BehaviorRelay<EventModel?>(value: nil)

    private(set) var selectedDate: Date
    private var calendar = Calendar.current
    private var event: EventModel?

    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        self.title = "New Event"
    }

    init(event: EventModel) {
        self.event = event
        self.selectedDate = event.date
        self.eventTitle.accept(event.title)
        self.title = "Edit Event"
    }

    func updateDate(_ date: Date) {
        let dateComponents = calendar.dateComponents([.hour, .minute], from: selectedDate)

        guard let hour = dateComponents.hour,
              let minute = dateComponents.minute,
              let updatedDate = calendar.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: date
              ) else { return }

        selectedDate = updatedDate
    }

    func updateTime(_ date: Date) {
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)

        guard let hour = dateComponents.hour,
              let minute = dateComponents.minute,
              let updatedDate = calendar.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: selectedDate
              ) else { return }

        selectedDate = updatedDate
    }

    func addEvent() {
        saveRelay.accept(EventModel(title: eventTitle.value, date: selectedDate))
    }

    func editEvent() {
        event?.title = eventTitle.value
        event?.date = selectedDate
        editRelay.accept(event)
    }
}
