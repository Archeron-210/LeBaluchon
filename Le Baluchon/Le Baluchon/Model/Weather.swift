

import Foundation

enum CityCode: String {
    case nyc = "5128581"
    case home = "6454726"
}

// Mapping JSON data from API response using Codable Protocol to parse it later  :
struct Weather: Codable {
    var weather: [WeatherDetails]
    var main: Temperature
}

struct WeatherDetails: Codable {
    var id: Int
    var description: String
}

struct Temperature: Codable {
    var temp: Double
}
