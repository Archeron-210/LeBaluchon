
import Foundation

class TraductorService {

    // MARK: - Error management

    enum TraductorError: Error {
        case requestError
        case noDataAvailable
        case parsingFailed
        case apiError
        case httpResponseError
    }

    // MARK: - Properties

    private(set) static var shared = TraductorService()

    private var task: URLSessionDataTask?
    private var session: URLSession

    private var resourceUrl: URL?
    private let apiKey = "API_KEY"

    // MARK: - Init

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        let resourceString = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        self.resourceUrl = URL(string: resourceString)
    }

    // MARK: - Functions
    
    func getTranslation(textToTranslate: String?, from language: Language, completion: @escaping(Result<TranslationData, TraductorError>) -> Void) {
        guard let request = createTranslationRequest(textToTranslate: textToTranslate, from: language) else {
            completion(.failure(.requestError))
            return
        }
        task = session.dataTask(with: request) {data, response, error in
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
    private func createTranslationRequest(textToTranslate: String?, from language: Language) -> URLRequest? {
        guard let url = resourceUrl else {
            return nil
        }
        guard let text = textToTranslate else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var body: String
        switch language {
        case .english:
            body = "q=\(text)&source=en&target=fr&format=text"
        case .french:
            body = "q=\(text)&source=fr&target=en&format=text"
        }
        request.httpBody = body.data(using: .utf8)
        return request
    }
}
