
import UIKit

class WeatherViewController: UIViewController {


    @IBOutlet weak var nycTemperatureLabel: UILabel!
    @IBOutlet weak var nycWeatherIcon: UIImageView!

    @IBOutlet weak var homeTemperatureLabel: UILabel!
    @IBOutlet weak var homeWeatherIcon: UIImageView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    

    @IBAction func toggleRefreshButton(_ sender: UIButton) {
    }


    override func viewDidLoad() {
        super.viewDidLoad()



    }
}
