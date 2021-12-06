@testable import Le_Baluchon
import XCTest

class WeatherServiceTestCase: XCTestCase {


    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: nil, response: nil, error: FakeTraductorResponseData.error))
        // When
        weatherService.getWeather(for: .nyc) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .apiError)
            case .success:
                XCTFail("Request should fail with apiError")
            }
        }
    }

    func testGetWeatherShouldPostFailedCallbackIfNoDataAvailable() {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        weatherService.getWeather(for: .nyc) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noDataAvailable)
            case .success:
                XCTFail("Request should fail with noDataAvailable")
            }
        }
    }

    func testGetWeatherShouldPostFailedCallbackIfCorrectDataButIncorrectResponse() {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeWeatherResponseData.weatherCorrectData, response: FakeWeatherResponseData.responseKO, error: nil))
        // When
        weatherService.getWeather(for: .nyc) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .httpResponseError)
            case .success:
                XCTFail("Request should fail with httpResponseError")
            }
        }
    }

    func testGetWeatherShouldPostFailedCallbackIfCorrectResponseButIncorrectData() {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeWeatherResponseData.weatherIncorrectData, response: FakeWeatherResponseData.responseOK, error: nil))
        // When
        weatherService.getWeather(for: .nyc) { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parsingFailed)
            case .success:
                XCTFail("Request should fail with parsingFailed")
            }
        }
    }

    func testGetWeatherShouldPostSuccessfulCallbackIfNoErrorAndCorrectResponseAndCorrectData() {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeWeatherResponseData.weatherCorrectData, response: FakeWeatherResponseData.responseOK, error: nil))
        // When
        weatherService.getWeather(for: .nyc) { result in
            // Then
            let weatherId = 803
            let description = "nuageux"
            let temperature = 7.56
            switch result {
            case .failure:
                XCTFail("Request should not fail")
            case .success(let weatherForecast):
                XCTAssertNotNil(weatherForecast)
                XCTAssertEqual(weatherId, weatherForecast.weather.first!.id)
                XCTAssertEqual(description, weatherForecast.weather.first!.description)
                XCTAssertEqual(temperature, weatherForecast.main.temp)
            }
        }
    }

}
