import Foundation

enum Helpers {
    static func stringDateFrom(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }

    static func stringTimeFrom(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    static func containsDate(date: Date, in dates: [Date]) -> Bool {
        let calendar = Calendar.current
        let componentsToFind = calendar.dateComponents([.year, .month, .day], from: date)
        for dateItem in dates {
            let components = calendar.dateComponents([.year, .month, .day], from: dateItem)
            if components == componentsToFind {
                return true
            }
        }
        return false
    }

    static func isWeekend(date: Date) -> Bool {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        return dayOfWeek == 1 || dayOfWeek == 7
    }

    static func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateComponents1 = calendar.dateComponents([.year, .month, .day], from: date)
        let dateComponents2 = calendar.dateComponents([.year, .month, .day], from: currentDate)
        return dateComponents1.year == dateComponents2.year &&
               dateComponents1.month == dateComponents2.month &&
               dateComponents1.day == dateComponents2.day
    }
}
