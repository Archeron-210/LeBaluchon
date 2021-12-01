
import Foundation

class WeatherService {

    // MARK: - Error management
    enum WeatherError: Error {
        case noDataAvailable
        case parsingFailed
        case urlError
        case apiError
        case httpResponseError
    }
    // MARK: - Properties
    private(set) static var shared = WeatherService()

    private var task: URLSessionDataTask?
    private(set) var nycSession = URLSession(configuration: .default)
    private(set) var homeSession = URLSession(configuration: .default)

    private var nycResourceUrl: URL?
    private var homeResourceUrl: URL?
    private let nycCode = "5128581"
    private let homeCode = "6454726"
    private let apiKey = "API_KEY"

    // MARK: - Init
    init() {
        let nycResourceString = "https://api.openweathermap.org/data/2.5/weather?id=\(nycCode)&appid=\(apiKey)&units=metric&lang=fr"
        self.nycResourceUrl = URL(string: nycResourceString)
        let homeResourceString = "https://api.openweathermap.org/data/2.5/weather?id=\(homeCode)&appid=\(apiKey)&units=metric&lang=fr"
        self.homeResourceUrl = URL(string: homeResourceString)
    }

    // MARK: - Get Weather Forecast
    func getNycWeather(completion: @escaping (Result<Weather, WeatherError>)-> Void) {
        guard let url = nycResourceUrl else {
            completion(.failure(.urlError))
            return
        }
        task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard error == nil else {
                completion(.failure(.apiError))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.httpResponseError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let nycWeatherForecast = try decoder.decode(Weather.self, from: jsonData)
                completion(.success(nycWeatherForecast))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        task?.resume()
    }

    func getHomeWeather(completion: @escaping (Result<Weather, WeatherError>)-> Void) {
        guard let url = homeResourceUrl else {
            completion(.failure(.urlError))
            return
        }
        task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard error == nil else {
                completion(.failure(.apiError))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.httpResponseError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let homeWeatherForecast = try decoder.decode(Weather.self, from: jsonData)
                completion(.success(homeWeatherForecast))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        task?.resume()
    }


}
