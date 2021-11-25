
import UIKit

class ChangeRateViewController: UIViewController {

    // MARK: - Properties

    var currentChangeRate: ChangeRate? {
        // display the result directly when obtaining a change rate :
        didSet {
            DispatchQueue.main.async {
                self.computeConversion()
            }
        }
    }

    // obtaining current date from DateService :
    let currentDate = DateService.currentDate

    // make textFields texts Double? :
    var eurosCurrentValue: Double? {
        guard let eurosText = eurosTextField.text else {
            return nil
        }
        return Double(eurosText)
    }
    var dollarsCurrentValue: Double? {
        guard let dollarsText = dollarsTextField.text else {
            return nil
        }
        return Double(dollarsText)
    }


    // MARK: - Outlets
    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        setConvertButtonCorners()
        setSegmentedControlAspect()
        getCurrentDate()

        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Functions
    @IBAction func toggleConvertButton(_ sender: UIButton) {
        computeConversion()
    }

    private func computeConversion() {
        switch currencySegmentedControl.selectedSegmentIndex {
        case 0:
            updateDollarTextfield()
        case 1:
            updateEuroTextField()
        default:
            break
        }
    }

    // Convert from euro to dollar, so we take the euro value
    // and update dollar textfield.
    private func updateDollarTextfield() {
        guard let value = eurosCurrentValue else {
            textFieldAlert()
            return
        }
        dollarsTextField.text = convert(from: .euro, value: value)
    }

    // Convert from dollar to euro, so we take the dollar value
    // and update euro textfield.
    private func updateEuroTextField() {
        guard let value = dollarsCurrentValue else {
            textFieldAlert()
            return
        }
        eurosTextField.text = convert(from: .dollar, value: value)
    }

    private func convert(from currency: Currency, value: Double) -> String? {
        guard let changeRate = currentChangeRate, changeRate.date == currentDate else {
            toggleActivityIndicator(shown: true)
            obtainCurrentChangeRate()
            return nil
        }

        let rate = changeRate.rates.USD

        switch currency {
        case .euro:
            let result = value * rate
            let resultToDisplay = String(result)
            return resultToDisplay
        case .dollar:
            let result = value / rate
            let resultToDisplay = String(result)
            return resultToDisplay
        }
    }

    private func obtainCurrentChangeRate() {
        ChangeRateService.shared.getChangeRate { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
            }
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.errorAlert()
                }
            case .success(let changeRate):
                self.currentChangeRate = changeRate
                // save date and rate here
            }
        }
    }

    private func getCurrentDate() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let currentDate = format.string(from: date)

        DateService.currentDate = currentDate
    }


    // MARK: - Alerts
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il semble que le courant passe mal avec le serveur 🔌", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    private func textFieldAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il faut d'abord entrer un montant dans le champ texte correspondant pour le convertir 💵", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UI Aspect
    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func setConvertButtonCorners() {
        convertButton.layer.cornerRadius = 25.0
    }

    @IBAction func currencyDidChange(_ sender: UISegmentedControl) {
        eurosTextField.text = ""
        dollarsTextField.text = ""
    }

    private func setSegmentedControlAspect() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        currencySegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }

    // MARK: - Keyboard Management
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        eurosTextField.resignFirstResponder()
        dollarsTextField.resignFirstResponder()
    }

    //@objc func keyboardWillShow(notification: NSNotification) {
       // if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           // self.converterStackView.frame.origin.y -= keyboardSize.height
        //}
    //}

    //@objc func keyboardWillHide(notification: NSNotification) {
       // self.converterStackView.frame.origin.y = 0
    //}

}
