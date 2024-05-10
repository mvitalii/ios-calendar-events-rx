import Foundation
import RxSwift
import RxCocoa

protocol EventService {
    var eventsObservable: Observable<[EventModel]> { get }
    var eventsValue: [EventModel] { get }
    func loadEvents()
    func saveEvent(_ event: EventModel)
    func editEvent(_ event: EventModel)
}

class LocalEventService: EventService {
    static let shared = LocalEventService()

    private let userDefaults = UserDefaults.standard
    private let eventsKey = "events"

    private let eventsRelay = BehaviorRelay<[EventModel]>(value: [])

    var eventsObservable: Observable<[EventModel]> { eventsRelay.asObservable() }
    var eventsValue: [EventModel] { eventsRelay.value }

    private init() {}

    func saveEvent(_ event: EventModel) {
        var currentEvents = eventsRelay.value
        currentEvents.append(event)
        saveToUserDefaults(currentEvents)
        print("Saved event \(event)")
    }

    func editEvent(_ event: EventModel) {
        var currentEvents = eventsRelay.value
        if let index = currentEvents.firstIndex(of: event) {
            var currentEvent = currentEvents[index]
            currentEvent.title = event.title
            currentEvent.date = event.date
            currentEvents[index] = currentEvent
            saveToUserDefaults(currentEvents)
            print("Edited event \(currentEvent)")
        }
    }

    func loadEvents() {
        if let eventsData = userDefaults.data(forKey: eventsKey) {
            if let events = try? JSONDecoder().decode([EventModel].self, from: eventsData) {
                eventsRelay.accept(events)
                print("Loaded events \(events)")
            }
        }
    }

    private func saveToUserDefaults(_ events: [EventModel]) {
        if let eventsData = try? JSONEncoder().encode(events) {
            userDefaults.set(eventsData, forKey: eventsKey)
            eventsRelay.accept(events)
        }
    }
}
