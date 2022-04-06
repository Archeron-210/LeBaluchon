
import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nycTemperatureLabel: UILabel!
    @IBOutlet weak var nycWeatherIcon: UIImageView!
    @IBOutlet weak var nycConditionLabel: UILabel!
    @IBOutlet weak var homeTemperatureLabel: UILabel!
    @IBOutlet weak var homeWeatherIcon: UIImageView!
    @IBOutlet weak var homeConditionLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Property

    private let aspectSetter = AspectSettings()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        aspectSetter.setButtonAspect(for: refreshButton)

        refreshWeather()
    }

    // MARK: - Functions
    @IBAction func toggleRefreshButton(_ sender: UIButton) {
        refreshWeather()
    }

    private func refreshWeather() {
        obtainCurrentWeather(for: .home)
        obtainCurrentWeather(for: .nyc)
    }

    private func obtainCurrentWeather(for cityCode: CityCode) {
        WeatherService.shared.getWeather(for: cityCode) { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let weatherForecast):
                    let temperature = String(weatherForecast.main.temp)
                    let description = weatherForecast.weather.first?.description ?? ""
                    let weatherId = weatherForecast.weather.first?.id ?? 802
                    self.updateLabels(for: cityCode, temperature: temperature, description: description)
                    self.updateWeatherIcon(for: cityCode, for: weatherId)
                }
            }
        }
    }

    private func updateLabels(for cityCode: CityCode, temperature: String, description: String) {
        let celsiusTemperature = "\(temperature)°C"
        switch cityCode {
        case .home:
            homeTemperatureLabel.text = celsiusTemperature
            homeConditionLabel.text = description.capitalizingFirstLetter()
        case .nyc:
            nycTemperatureLabel.text = celsiusTemperature
            nycConditionLabel.text = description.capitalizingFirstLetter()
        }
    }

    private func updateWeatherIcon(for cityCode: CityCode, for id: Int) {
        switch cityCode {
        case .home:
            homeWeatherIcon.image = getWeatherIcon(for: id)
        case .nyc:
            nycWeatherIcon.image = getWeatherIcon(for: id)
        }
    }

    private func getWeatherIcon(for weatherID: Int) -> UIImage? {
        let value = weatherID
        switch value {
        case 200...232:
            return UIImage(systemName: "cloud.bolt")
        case 300...321:
            return UIImage(systemName: "cloud.drizzle")
        case 500...531:
            return UIImage(systemName: "cloud.rain")
        case 600...622:
            return UIImage(systemName: "snow")
        case 701...781:
            return UIImage(systemName: "cloud.fog")
        case 800:
            return UIImage(systemName: "sun.max")
        case 801:
            return UIImage(systemName: "cloud.sun")
        case 802...804:
            return UIImage(systemName: "smoke")
        default:
            return UIImage(systemName: "cloud.sun")
        }
    }



    // MARK: - Alert
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il semble que le courant passe mal avec le serveur 🔌", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }


    // MARK: - UI Aspect
    private func toggleActivityIndicator(shown: Bool) {
        refreshButton.isHidden = shown
        activityIndicator.isHidden = !shown
        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

