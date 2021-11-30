
import Foundation

class TraductorService {

    // MARK: - Error management
    enum TraductorError: Error {
        case noDataAvailable
        case parsingFailed
        case urlError
        case apiError
        case httpResponseError
    }

    // MARK: - Properties
    private(set) static var shared = TraductorService()

    private var task: URLSessionDataTask?
    private(set) var session = URLSession(configuration: .default)

    private var resourceUrl: URL?
    private let apiKey = "API_KEY"

    // MARK: - Init
    init() {
        let resourceString = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        self.resourceUrl = URL(string: resourceString)
    }

    // MARK: - Functions
    func getTranslation(textToTranslate: String?, completion: @escaping(Result<TranslationData, TraductorError>)-> Void) {
        guard let request = createTranslationRequest(textToTranslate: textToTranslate) else {
            return
        }
        task = URLSession.shared.dataTask(with: request) {data, response, error in
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
                let traductor = try decoder.decode(TranslationData.self, from: jsonData)
                completion(.success(traductor))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        task?.resume()
    }

    // returns a URLRequest? with a functionnal body :
    private func createTranslationRequest(textToTranslate: String?) -> URLRequest? {
        guard let url = resourceUrl else {
            return nil
        }
        guard let text = textToTranslate else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "q=\(text)&source=en&target=fr&format=text"
        request.httpBody = body.data(using: .utf8)
        return request
    }
}
