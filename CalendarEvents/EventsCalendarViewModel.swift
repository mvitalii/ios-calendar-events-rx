import Foundation
import RxSwift
import RxCocoa

class EventsCalendarViewModel {

    private let service: EventService
    var events: Observable<[EventModel]> { service.eventsObservable }

    var editRelay = BehaviorRelay<EventModel?>(value: nil)

    init(service: EventService) {
        self.service = service
    }

    func loadEvents() {
        service.loadEvents()
    }

    func selectEvent(at indexPath: IndexPath) {
        let event = service.eventsValue[indexPath.row]
        editRelay.accept(event)
    }
}
