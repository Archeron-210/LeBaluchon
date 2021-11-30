

import UIKit

class TraductorViewController: UIViewController {

    // MARK: - Properties
    private var translatedText = ""

    // MARK: - Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        toggleActivityIndicator(shown: false)
        setTranslateButtonCorners()
        setSegmentedControlAspect()

    }

    // MARK: - Functions
    @IBAction func toggleTranslationButton(_ sender: UIButton) {
        translate()
    }
    
    private func translate() {
        TraductorService.shared.getTranslation(textToTranslate: textView.text) { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
            }
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.errorAlert()
                }
            case .success(let traductor):
                self.translatedText = traductor.data.translations.first?.translatedText ?? ""
                self.updateTextView()
            }
        }
    }

    private func updateTextView() {
        DispatchQueue.main.async {
            self.textView.text = self.translatedText
        }
    }

    // MARK: - Alerts
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il semble que le courant passe mal avec le serveur 🔌", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    private func textViewAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il faut d'abord entrer une phrase dans le champ texte pour la traduire 📝", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UI Aspect
    private func toggleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func setTranslateButtonCorners() {
        translateButton.layer.cornerRadius = 25.0
    }

    private func setSegmentedControlAspect() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        languageSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }

    // MARK: - Keyboard Management
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }

}
