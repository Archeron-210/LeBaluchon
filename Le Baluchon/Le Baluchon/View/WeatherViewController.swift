
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
                    guard let weatherId = weatherForecast.weather.first?.id else {
                        return
                    }
                    self.updateLabels(for: cityCode, temperature: temperature, description: description)
                    self.updateWeatherIcon(for: cityCode, for: weatherId)
                }
            }
        }
    }

    private func updateLabels(for cityCode: WeatherService.CityCode, temperature: String, description: String) {
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

    private func updateWeatherIcon(for cityCode: WeatherService.CityCode, for id: Int) {
        switch cityCode {
        case .home:
            setWeatherIcon(imageView: homeWeatherIcon, for: id)
        case .nyc:
            setWeatherIcon(imageView: nycWeatherIcon, for: id)
        }
    }

    private func setWeatherIcon(imageView: UIImageView, for weatherID: Int) {
        let value = weatherID
        if 200...232 ~= value {
            imageView.image = UIImage(systemName: "cloud.bolt")
        }
        if 300...321 ~= value {
            imageView.image = UIImage(systemName: "cloud.drizzle")
        }
        if 500...531 ~= value {
            imageView.image = UIImage(systemName: "cloud.rain")
        }
        if 600...622 ~= value {
            imageView.image = UIImage(systemName: "snow")
        }
        if 701...781 ~= value {
            imageView.image = UIImage(systemName: "cloud.fog")
        }
        if value == 800 {
            imageView.image = UIImage(systemName: "sun.max")
        }
        if value == 801 {
            imageView.image = UIImage(systemName: "cloud.sun")
        }
        if 802...804 ~= value {
            imageView.image = UIImage(systemName: "smoke")
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
