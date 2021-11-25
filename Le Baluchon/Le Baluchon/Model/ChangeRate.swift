
import Foundation


enum Currency {
    case euro
    case dollar
}

// Mapping the JSON data from API response using Codable Protocol to parse it later  :

struct ChangeRate: Codable {
    var date: String
    var rates: Rate
}

struct Rate: Codable {
    var USD: Double
}


