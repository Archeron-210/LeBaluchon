
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
    private var session: URLSession
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    private let apiKey = "API_KEY"
    private let baseUrl: String = "https://api.openweathermap.org/data/2.5/weather"


    // MARK: - Functions
    
    func getWeather(for cityCode: CityCode, completion: @escaping (Result<Weather, WeatherError>)-> Void) {
        guard let url = resourceUrl(for: cityCode) else {
            completion(.failure(.urlError))
            return
        }
        task = session.dataTask(with: url) {data, response, error in
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
                let weatherForecast = try decoder.decode(Weather.self, from: jsonData)
                completion(.success(weatherForecast))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        task?.resume()
    }

    private func resourceUrl(for cityCode: CityCode) -> URL? {
        let rawUrl = "\(baseUrl)?id=\(cityCode.rawValue)&appid=\(apiKey)&units=metric&lang=fr"
        return URL(string: rawUrl)
    }
}
