

import Foundation

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
