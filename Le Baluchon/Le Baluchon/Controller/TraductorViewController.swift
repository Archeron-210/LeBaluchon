

import UIKit

class TraductorViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties

    private var originalStackViewBottomConstraint: CGFloat = 0.0
    private var translatedText = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        originalStackViewBottomConstraint = stackViewBottomConstraint.constant
        toggleActivityIndicator(shown: false)
        setTranslateButtonCorners()
        setSegmentedControlAspect()
        listenKeyboardNotifications()
    }

    // MARK: - Functions
    @IBAction func toggleTranslationButton(_ sender: UIButton) {
        guard !textView.text.isEmpty else {
            textViewAlert()
            return
        }
        translate()
    }
    
    private func translate() {
        guard let language = switchLanguage() else {
            return
        }
        TraductorService.shared.getTranslation(textToTranslate: textView.text, from: language) { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                switch result {
                case .failure:
                    self.errorAlert()
                case .success(let traductor):
                    self.translatedText = traductor.data.translations.first?.translatedText ?? ""
                    self.updateTextView()
                }
            }
        }
    }

    private func updateTextView() {
        DispatchQueue.main.async {
            self.textView.text = self.translatedText
        }
    }

    private func switchLanguage() -> Language? {
        switch languageSegmentedControl.selectedSegmentIndex {
        case 0 :
            return .french
        case 1 :
            return .english
        default :
            return nil
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
}

extension TraductorViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

    // MARK: - Keyboard Management
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }

    private func listenKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // to make the stackView go up a bit when the keyboard appears :
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        stackViewBottomConstraint.constant = keyboardSize.height + 2
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    // to make the stackView go back to its original position when the keyboard disappears :
    @objc func keyboardWillHide(notification: NSNotification) {
        stackViewBottomConstraint.constant = originalStackViewBottomConstraint
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }

}
