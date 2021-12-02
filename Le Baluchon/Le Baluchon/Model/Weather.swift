

import Foundation

enum CityCode: String {
    case nyc = "5128581"
    case home = "6454726"
}

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
