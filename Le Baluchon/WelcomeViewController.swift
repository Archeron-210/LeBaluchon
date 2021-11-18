

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var changeRateButton: UIButton!
    @IBOutlet weak var traductorButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherButton.layer.cornerRadius = 25.0
        changeRateButton.layer.cornerRadius = 25.0
        traductorButton.layer.cornerRadius = 25.0
    }

}
