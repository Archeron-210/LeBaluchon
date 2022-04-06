

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var changeRateButton: UIButton!
    @IBOutlet weak var traductorButton: UIButton!

    // MARK: - Property

    private let aspectSetter = AspectSettings()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        aspectSetter.setButtonAspect(for: weatherButton)
        aspectSetter.setButtonAspect(for: changeRateButton)
        aspectSetter.setButtonAspect(for: traductorButton)
    }
}
