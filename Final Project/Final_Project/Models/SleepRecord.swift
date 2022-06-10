import Foundation
import RealmSwift

enum SleepQuality: String, PersistableEnum, CaseIterable {
    
    case great
    case good
    case ok
    case bad
    
    
    var text: String {
        rawValue.capitalized
    }
    
    var emoji: String {
        switch self {
        case .great:
            return "😁"
        case .good:
            return "🙂"
        case .ok:
            return "😐"
        case .bad:
            return "🙁"
        }
    }
    
    static var last: SleepQuality {
        return SleepQuality.allCases[SleepQuality.allCases.count - 1]
    }
}

final class SleepRecord: Object, Identifiable, ObjectKeyIdentifiable {
    
    private var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
    
    convenience init(sleepStart: Date, sleepEnd: Date, sleepQuality: SleepQuality) {
        self.init()
        self.sleepStart = sleepStart
        self.sleepEnd = sleepEnd
        self.sleepQuality = sleepQuality
    }
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var sleepStart: Date
    @Persisted var sleepEnd: Date
    @Persisted var sleepQuality: SleepQuality
    
    var interval: DateInterval {
        DateInterval(start: self.sleepStart, end: self.sleepEnd)
    }
    
    var timeFormatted: String {
        timeFormatter.string(from: interval.duration) ?? ""
    }
    
    var startDateFormatted: String {
        dateFormatter.string(from: sleepStart)
    }
    
    var endDateFormatted: String {
        dateFormatter.string(from: sleepEnd)
    }
    
    var startDateTimeFormatted: String {
        dateTimeFormatter.string(from: sleepStart)
    }
    
    var endDateTimeFormatted: String {
        dateTimeFormatter.string(from: sleepEnd)
    }

    
}
