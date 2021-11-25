
import Foundation

class DateService {

    private struct Keys {
        static let currentDate = "currentDate"
    }

    static var currentDate: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.currentDate) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currentDate)
        }
    }
}
