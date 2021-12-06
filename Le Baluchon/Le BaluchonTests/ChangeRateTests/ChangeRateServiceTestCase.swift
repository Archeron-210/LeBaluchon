@testable import Le_Baluchon
import XCTest

class ChangeRateServiceTestCase: XCTestCase {

    func testGetChangeRateShouldPostFailedCallbackIfError() {
        // Given
        let changeRateService = ChangeRateService(session: URLSessionFake(data: nil, response: nil, error: FakeChangeRateResponseData.error))
        // When
        changeRateService.getChangeRate { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .apiError)
            case .success:
                XCTFail("Request should fail with apiError")
            }
        }
    }

    func testGetChangeRateShouldPostFailedCallbackIfNoDataAvailable() {
        // Given
        let changeRateService = ChangeRateService(session: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        changeRateService.getChangeRate { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noDataAvailable)
            case .success:
                XCTFail("Request should fail with noDataAvailable")
            }
        }
    }

    func testGetChangeRateShouldPostFailedCallbackIfCorrectDataButIncorrectResponse() {
        // Given
        let changeRateService = ChangeRateService(session: URLSessionFake(data: FakeChangeRateResponseData.changeRateCorrectData, response: FakeChangeRateResponseData.responseKO, error: nil))
        // When
        changeRateService.getChangeRate { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .httpResponseError)
            case .success:
                XCTFail("Request should fail with httpResponseError")
            }
        }
    }

    func testGetChangeRateShouldPostFailedCallbackIfCorrectResponseButIncorrectData() {
        // Given
        let changeRateService = ChangeRateService(session: URLSessionFake(data: FakeChangeRateResponseData.changeRateIncorrectData, response: FakeChangeRateResponseData.responseOK, error: nil))
        // When
        changeRateService.getChangeRate { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parsingFailed)
            case .success:
                XCTFail("Request should fail with parsingFailed")
            }
        }
    }

    func testGetChangeRateShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        // Given
        let changeRateService = ChangeRateService(session: URLSessionFake(data: FakeChangeRateResponseData.changeRateCorrectData, response: FakeChangeRateResponseData.responseOK, error: nil))
        // When
        changeRateService.getChangeRate { result in
            // Then
            let date = "2021-12-03"
            let rates = 1.131164
            switch result {
            case .failure:
                XCTFail("Request should not fail")
            case .success(let changeRate):
                XCTAssertNotNil(changeRate)
                XCTAssertEqual(date, changeRate.date)
                XCTAssertEqual(rates, changeRate.rates.USD)
            }
        }
    }

}
