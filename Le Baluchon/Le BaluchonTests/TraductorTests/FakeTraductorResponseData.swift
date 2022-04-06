
import Foundation

class FakeTraductorResponseData {

    // MARK: - Data

    static var traductorCorrectData: Data? {
        let bundle = Bundle(for: FakeTraductorResponseData.self)
        let url = bundle.url(forResource: "Traductor", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let traductorIncorrectData = "erreur".data(using: .utf8)!

    // MARK: - Response

    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    // MARK: - Error
    
    class FakeTraductorError: Error {}
    static let error = FakeTraductorError()
}
