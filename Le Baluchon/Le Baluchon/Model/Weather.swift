

import Foundation

struct Weather: Codable {
    var weatherDetails: [WeatherDetails]
    var temperature: Temperature
}

struct WeatherDetails: Codable {
    var id: Int
    var description: String
}

struct Temperature: Codable {
    var temp: Double
}
