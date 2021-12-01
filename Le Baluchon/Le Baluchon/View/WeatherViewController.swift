
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
    }


    @IBAction func toggleRefreshButton(_ sender: UIButton) {
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
