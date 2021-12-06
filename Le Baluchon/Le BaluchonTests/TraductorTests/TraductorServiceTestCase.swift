@testable import Le_Baluchon
import XCTest

class TraductorServiceTestCase: XCTestCase {

    private let testText = "Hello World"

    func testGetTraductorShouldPostFailedCallbackIfError() {
        // Given
        let traductorService = TraductorService(session: URLSessionFake(data: nil, response: nil, error: FakeTraductorResponseData.error))
        // When
        traductorService.getTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .apiError)
            case .success:
                XCTFail("Request should fail with apiError")
            }
        }
    }

    func testGetTraductorShouldPostFailedCallbackIfNoDataAvailable() {
        // Given
        let traductorService = TraductorService(session: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        traductorService.getTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noDataAvailable)
            case .success:
                XCTFail("Request should fail with noDataAvailable")
            }
        }
    }

    func testGetTraductorShouldPostFailedCallbackIfCorrectDataButIncorrectResponse() {
        // Given
        let traductorService = TraductorService(session: URLSessionFake(data: FakeTraductorResponseData.traductorCorrectData, response: FakeTraductorResponseData.responseKO, error: nil))
        // When
        traductorService.getTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .httpResponseError)
            case .success:
                XCTFail("Request should fail with httpResponseError")
            }
        }
    }

    func testGetTraductorShouldPostFailedCallbackIfCorrectResponseButIncorrectData() {
        // Given
        let traductorService = TraductorService(session: URLSessionFake(data: FakeTraductorResponseData.traductorIncorrectData, response: FakeTraductorResponseData.responseOK, error: nil))
        // When
        traductorService.getTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parsingFailed)
            case .success:
                XCTFail("Request should fail with parsingFailed")
            }
        }
    }

    func testGetTraductorShouldPostFailedCallbackIfNoErrorAndCorrectResponseAndCorrectDataButRequestBuildingFailed() {
        // Given
        let traductorService = TraductorService(session: URLSessionFake(data: FakeTraductorResponseData.traductorCorrectData, response: FakeTraductorResponseData.responseOK, error: nil))
        // When
        traductorService.getTranslation(textToTranslate: nil, from: .french) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .requestError)
            case .success:
                XCTFail("Request should fail with requestError")
            }
        }
    }

    func testGetTraductorShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        // Given
        let traductorService = TraductorService(session: URLSessionFake(data: FakeTraductorResponseData.traductorCorrectData, response: FakeTraductorResponseData.responseOK, error: nil))
        // When
        traductorService.getTranslation(textToTranslate: testText, from: .english) { result in
            // Then
            let translatedText = "Bonjour Monde"
            switch result {
            case .failure:
                XCTFail("Request should not fail")
            case .success(let traductor):
                XCTAssertNotNil(traductor)
                XCTAssertEqual(translatedText, traductor.data.translations.first!.translatedText)
            }
        }
    }

}
