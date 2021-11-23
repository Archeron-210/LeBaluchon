
import Foundation

class ChangeRateService {

    enum ChangeRateError: Error {
        case noDataAvailable
        case parsingFailed
        case urlError
        case apiError
        case httpResponseError
    }

    private(set) static var shared = ChangeRateService()

    private var task: URLSessionDataTask?
    private(set) var session = URLSession(configuration: .default)

    private var resourceUrl: URL?
    private let apiKey = "cd00e39fcd27cab07cec878d55125e50"

    init() {
        let resourceString = "http://data.fixer.io/api/latest?access_key=\(apiKey)&symbols=USD&format=1"
        guard let resourceUrl = URL(string: resourceString) else {
            self.resourceUrl = nil
            return
        }
        self.resourceUrl = resourceUrl
    }

    func getChangeRate(completion: @escaping (Result<ChangeRate, ChangeRateError>)-> Void) {

        guard let url = resourceUrl else {
            completion(.failure(.urlError))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) {data, response, error in
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
                let changeRate = try decoder.decode(ChangeRate.self, from: jsonData)
                completion(.success(changeRate))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        dataTask.resume()
    }

}
