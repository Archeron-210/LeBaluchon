
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        setRefreshButtonCorners()
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

    private func obtainCurrentWeather(for cityCode: WeatherService.CityCode) {
        WeatherService.shared.getWeather(for: cityCode) { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let weatherForecast):
                    let temperature = String(weatherForecast.main.temp)
                    let description = weatherForecast.weather.first?.description ?? ""
                    self.updateLabels(for: cityCode, temperature: temperature, description: description)
                    self.updateWeatherIcon(for: cityCode)
                }
            }
        }
    }

    private func updateLabels(for cityCode: WeatherService.CityCode, temperature: String, description: String) {
        let celsiusTemperature = "\(temperature)°C"
        switch cityCode {
        case .home:
            homeTemperatureLabel.text = celsiusTemperature
            homeConditionLabel.text = description
        case .nyc:
            nycTemperatureLabel.text = celsiusTemperature
            nycConditionLabel.text = description
        }
    }

    private func updateWeatherIcon(for cityCode: WeatherService.CityCode) {
        switch cityCode {
        case .home:
            print("homeIcon")
        case .nyc:
            print("nycIcon")
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

    private func setRefreshButtonCorners() {
        refreshButton.layer.cornerRadius = 25.0
    }
}
