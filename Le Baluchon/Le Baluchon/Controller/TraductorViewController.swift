

import UIKit

class TraductorViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    @IBAction func toggleTranslationButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        translateButton.layer.cornerRadius = 25.0

    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }

}
