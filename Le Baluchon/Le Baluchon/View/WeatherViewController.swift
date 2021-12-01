
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

    // MARK: - Properties
    private var nycTemperature = "°C"
    private var nycWeatherDescription = ""
    private var homeTemperature = "°C"
    private var homeWeatherDescription = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        setRefreshButtonCorners()
    }

    // MARK: - Functions
    @IBAction func toggleRefreshButton(_ sender: UIButton) {
        obtainCurrentNycWeather()
        obtainCurrentHomeWeather()
    }

    private func obtainCurrentNycWeather() {
        WeatherService.shared.getNycWeather { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let nycWeatherForecast):
                    self.nycTemperature = String(nycWeatherForecast.temperature.temp)
                    self.nycWeatherDescription = nycWeatherForecast.weatherDetails.description
                    self.updateNycLabels()
                    self.updateNycWeatherIcon()
                }
            }
        }
    }

    private func obtainCurrentHomeWeather() {
        WeatherService.shared.getHomeWeather { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let homeWeatherForecast):
                    self.homeTemperature = String(homeWeatherForecast.temperature.temp)
                    self.homeWeatherDescription = homeWeatherForecast.weatherDetails.description
                    self.updateHomeLabels()
                    self.updateHomeWeatherIcon()
                }
            }
        }
    }

    private func updateNycLabels() {
        nycTemperatureLabel.text = "\(nycTemperature)°C"
        nycConditionLabel.text = "\(nycWeatherDescription)"
    }

    private func updateHomeLabels() {
        homeTemperatureLabel.text = "\(homeTemperature)°C"
        homeConditionLabel.text = "\(homeWeatherDescription)"
    }

    private func updateNycWeatherIcon() {
        print("nycIcon")
    }

    private func updateHomeWeatherIcon() {
        print("homeIcon")
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
